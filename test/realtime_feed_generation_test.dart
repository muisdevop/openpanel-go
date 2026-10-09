import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:openpanel_go/core/models/project_config.dart';
import 'package:openpanel_go/core/network/dio_client.dart';
import 'package:openpanel_go/core/providers.dart';
import 'package:openpanel_go/core/storage/local_store.dart';
import 'package:openpanel_go/features/realtime/data/event_models.dart';
import 'package:openpanel_go/features/realtime/data/events_repository.dart';

/// A scripted page handed out by [_FakeRepo] in call order, with the delay that
/// lets a test force two in-flight fetches to complete out of order.
class _Page {
  const _Page({
    required this.events,
    required this.delay,
    this.skipped = 0,
  });
  final List<OpenPanelEvent> events;
  final Duration delay;
  final int skipped;
}

class _FakeRepo extends EventsRepository {
  _FakeRepo(this._pages)
    : super(
        OpenPanelApi(
          const ApiCredentials(
            baseUrl: 'https://x.test',
            clientId: 'cid',
            clientSecret: 'sec',
          ),
        ),
        ProjectConfig(
          id: 'p1',
          name: 'P',
          baseUrl: 'https://x.test',
          projectId: 'proj',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

  final List<_Page> _pages;
  int _calls = 0;

  @override
  Future<({List<OpenPanelEvent> events, int skipped})> fetchLatest({
    int limit = 100,
    String? eventName,
    Duration window = const Duration(hours: 24),
  }) async {
    final page = _pages[_calls++];
    await Future<void>.delayed(page.delay);
    return (events: page.events, skipped: page.skipped);
  }
}

OpenPanelEvent _ev(String id, String name) =>
    OpenPanelEvent(id: id, name: name, timestamp: DateTime.utc(2026, 1, 1));

void main() {
  late Directory dir;
  late LocalStore store;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('openpanel_realtime_gen');
    store = await LocalStore.open(hiveDir: dir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  // build() watches realtimeEventNameProvider and poll() reads
  // realtimeFiltersProvider; both transitively watch activeProjectIdProvider →
  // localStoreProvider, so the store must be overridden for the chain to build.
  ProviderContainer container(EventsRepository repo) => ProviderContainer(
    overrides: [
      localStoreProvider.overrideWithValue(store),
      eventsRepositoryProvider.overrideWith((_) async => repo),
    ],
  );

  test('a poll that lands before the pending build is not rewound by it', () async {
    // build() fetches pageA but is slow; poll() fetches pageB and is fast.
    // pageA was issued first (seq 1) yet resolves last — the generation guard
    // must make it re-assert pageB instead of rewinding the feed to stale data.
    final repo = _FakeRepo([
      _Page(
        events: [_ev('a1', 'aev'), _ev('a2', 'aev')],
        delay: const Duration(milliseconds: 25),
      ),
      _Page(events: [_ev('b1', 'bev')], delay: const Duration(milliseconds: 5)),
    ]);

    final c = container(repo);
    addTearDown(c.dispose);
    // realtimeEventsProvider is autoDispose; a bare .read lets the element tear
    // down between accesses and resets its _issued/_applied counters. A listener
    // pins one notifier instance so build and poll share the generation state.
    c.listen(realtimeEventsProvider, (_, _) {});

    // Kick off build(); let it pass its repository await and enter fetchLatest
    // (so it takes seq 1) before poll() is called.
    final buildFuture = c.read(realtimeEventsProvider.future);
    await Future<void>.delayed(const Duration(milliseconds: 1));

    final notifier = c.read(realtimeEventsProvider.notifier);
    await notifier.poll(); // takes seq 2, completes first (5ms)

    // The losing build future must resolve to pageB, never pageA.
    final buildResult = await buildFuture; // pageA's request, guarded away
    expect(buildResult.map((e) => e.id), ['b1']);

    final shown = c.read(realtimeEventsProvider).value!;
    expect(shown.map((e) => e.id), ['b1']);
    // pageA never committed, so its name never enters the filter vocabulary.
    expect(notifier.knownNames, {'bev'});
    expect(notifier.skipped, 0);
  });

  test('a poll issued after the build wins even when it resolves later', () async {
    // The guard orders by issue sequence, not completion time: build (seq 1) is
    // fast, the poll issued after it (seq 2) is slow. The poll reflects the
    // newest request/filters and MUST win, so a legitimately-newer response is
    // never discarded by the same counter that discards the stale one above.
    final repo = _FakeRepo([
      _Page(events: [_ev('b1', 'bev')], delay: const Duration(milliseconds: 5)),
      _Page(
        events: [_ev('a1', 'aev')],
        delay: const Duration(milliseconds: 25),
        skipped: 3,
      ),
    ]);

    final c = container(repo);
    addTearDown(c.dispose);
    c.listen(realtimeEventsProvider, (_, _) {});

    final buildFuture = c.read(realtimeEventsProvider.future);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    final notifier = c.read(realtimeEventsProvider.notifier);

    final pollFuture = notifier.poll(); // seq 2, slower pageA
    await buildFuture; // seq 1 commits pageB first
    await pollFuture; // seq 2 then commits pageA over it

    final shown = c.read(realtimeEventsProvider).value!;
    expect(shown.map((e) => e.id), ['a1']);
    expect(notifier.skipped, 3);
    // pageA was new relative to pageB, so its id highlights.
    expect(notifier.freshIds, {'a1'});
  });
}
