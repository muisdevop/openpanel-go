import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/project_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/providers.dart';
import 'event_models.dart';

part 'events_repository.g.dart';

class EventsRepository {
  EventsRepository(this._api, this._project);

  final OpenPanelApi _api;
  final ProjectConfig _project;

  /// Newest events first. The server orders by `created_at DESC`; there is
  /// no `orderBy` param. We pass `start` (24h ago) so the window is explicit.
  ///
  /// The second field is how many rows were dropped because the payload was
  /// unusable — surfaced in the feed footer rather than silently ignored.
  Future<({List<OpenPanelEvent> events, int skipped})> fetchLatest({
    int limit = 100,
    String? eventName,
    Duration window = const Duration(hours: 24),
  }) async {
    final body = await _api.get(
      ApiConstants.exportEvents,
      query: {
        'projectId': _project.projectId,
        'limit': limit,
        'start': DateTime.now().toUtc().subtract(window).toIso8601String(),
        'includes': ApiConstants.eventIncludes.join(','),
        'event': ?eventName,
      },
    );
    final list = body is Map ? body['data'] : null;
    if (list is! List) return (events: const <OpenPanelEvent>[], skipped: 0);
    final events = <OpenPanelEvent>[];
    var skipped = 0;
    for (var i = 0; i < list.length; i++) {
      final raw = list[i];
      if (raw is! Map) {
        skipped++;
        continue;
      }
      final parsed = OpenPanelEvent.tryFromApi(
        Map<String, dynamic>.from(raw),
        ordinal: i,
      );
      if (parsed == null) {
        skipped++;
        continue;
      }
      events.add(parsed);
    }
    return (events: events, skipped: skipped);
  }

  /// `GET /insights/{projectId}/live` → `{ visitors: n }`.
  Future<int?> fetchLiveVisitors() async {
    final body = await _api.get(ApiConstants.insightsLive(_project.projectId));
    final visitors = body is Map ? body['visitors'] : null;
    // A response this version can't read is not "zero people are online". It
    // has to come back as absence, or the feed renders a confident 0.
    return visitors is num ? visitors.toInt() : null;
  }
}

@riverpod
Future<EventsRepository?> eventsRepository(Ref ref) async {
  final project = ref.watch(activeProjectProvider);
  if (project == null) return null;
  // Throws ApiException.noCredentials when the secret isn't on this device,
  // which surfaces as an error state instead of a "no events" feed.
  final api = await ref.watch(activeApiProvider.future);
  return EventsRepository(api!, project);
}

/// Live feed filters.
@riverpod
class RealtimeFilters extends _$RealtimeFilters {
  @override
  EventFilters build() {
    // Watched so switching projects resets the feed filters. An event name
    // from project A applied to project B's feed silently empties it, and the
    // empty state reads as "this project has no traffic".
    ref.watch(activeProjectIdProvider);
    return const EventFilters();
  }

  void set(EventFilters f) => state = f;
  void clear() => state = const EventFilters();
}

/// Only the event-name filter is server-side; this keeps country/device
/// changes from triggering a refetch.
@riverpod
String? realtimeEventName(Ref ref) =>
    ref.watch(realtimeFiltersProvider).eventName;

/// Live feed. [poll] refreshes silently and keeps the list on screen.
@riverpod
class RealtimeEvents extends _$RealtimeEvents {
  /// IDs that appeared in the latest poll (for the highlight animation).
  Set<String> freshIds = {};

  /// Every event name seen so far (feeds the filter dropdown).
  final Set<String> knownNames = {};

  /// Rows dropped because their payload was unusable.
  int skipped = 0;

  /// When the feed last successfully updated, and what broke since. The UI
  /// needs both: a poll that fails after a first success must not leave the
  /// "Live" badge pulsing over frozen data with no indication.
  DateTime? lastUpdated;
  Object? lastError;

  bool _inFlight = false;
  int _issued = 0;
  int _applied = 0;

  /// The list the newest winning generation produced. A request that loses the
  /// race returns this instead of its own payload, so Riverpod's state write
  /// re-asserts current data rather than rewinding the feed.
  List<OpenPanelEvent> _latest = const [];

  @override
  Future<List<OpenPanelEvent>> build() async {
    final repo = await ref.watch(eventsRepositoryProvider.future);
    final eventName = ref.watch(realtimeEventNameProvider);
    if (repo == null) throwNoProject();
    final seq = ++_issued;
    final page = await repo.fetchLatest(eventName: eventName);
    return _commit(seq, page, const <String>{}, staleIds: false);
  }

  Future<void> poll() async {
    // `Timer.periodic` does not wait for async work, and a single request can
    // outlive several ticks (30s receive timeout × 3 attempts). Without this
    // guard, polls overlap and an older response can land last, rewinding the
    // feed.
    if (_inFlight) return;
    _inFlight = true;
    final seq = ++_issued;
    try {
      final repo = await ref.read(eventsRepositoryProvider.future);
      if (repo == null) throwNoProject();
      final eventName = ref.read(realtimeFiltersProvider).eventName;
      final page = await repo.fetchLatest(eventName: eventName);
      final old = state.value?.map((e) => e.id).toSet() ?? const <String>{};
      lastError = null;
      state = AsyncData(_commit(seq, page, old, staleIds: old.isNotEmpty));
    } on ApiException catch (e) {
      if (e.isSilent) return;
      _fail(e);
    } catch (e) {
      _fail(e);
    } finally {
      _inFlight = false;
    }
  }

  void _fail(Object e) {
    lastError = e;
    // Keep showing the last list, but only surface an error screen when there
    // is nothing to show.
    if (!state.hasValue) state = AsyncError(e, StackTrace.current);
  }

  /// Applies a page unless a newer generation already committed. `poll()` used
  /// to be the only caller holding a token, so a poll started against the old
  /// project could land after `build()` had fetched the new one and overwrite
  /// it — the client-side filters cannot catch that, since country and device
  /// match across projects.
  List<OpenPanelEvent> _commit(
    int seq,
    ({List<OpenPanelEvent> events, int skipped}) page,
    Set<String> old, {
    required bool staleIds,
  }) {
    if (seq < _applied) return _latest;
    _applied = seq;
    skipped = page.skipped;
    knownNames.addAll(page.events.map((e) => e.name));
    freshIds = staleIds
        ? page.events.map((e) => e.id).where((id) => !old.contains(id)).toSet()
        : <String>{};
    lastUpdated = DateTime.now();
    return _latest = page.events;
  }
}

@riverpod
Future<int?> liveVisitors(Ref ref) async {
  final repo = await ref.watch(eventsRepositoryProvider.future);
  if (repo == null) return null;
  try {
    return await repo.fetchLiveVisitors();
  } catch (_) {
    return null; // Non-critical; older self-hosted versions may lack it.
  }
}
