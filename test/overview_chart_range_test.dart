import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:openpanel_go/core/models/date_range.dart';
import 'package:openpanel_go/core/models/project_config.dart';
import 'package:openpanel_go/core/network/dio_client.dart';
import 'package:openpanel_go/core/storage/local_store.dart';
import 'package:openpanel_go/features/overview/data/overview_repository.dart';

/// The metrics path builds its query from the model's toQuery(), which
/// date_range_test already pins. The chart path is the one that does NOT:
/// `_chartRange` hand-assembles explicit bounds from `needsExplicitBounds`, so
/// a regression that forgets `lastMonth` there would send `range=custom` with
/// no dates (or the wrong token) and silently plot the wrong window. Nothing
/// else catches that, so this drives the real repository.
class _RecordingApi extends OpenPanelApi {
  _RecordingApi()
    : super(
        const ApiCredentials(
          baseUrl: 'https://x.test',
          clientId: 'cid',
          clientSecret: 'sec',
        ),
      );

  final captured = <Map<String, dynamic>>[];

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    captured.add(query ?? const {});
    // Body shape is irrelevant: the query is recorded before any parsing, and
    // the chart call's own parsing is wrapped in a catch by the tests.
    return const {};
  }
}

void main() {
  late Directory dir;
  late LocalStore store;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('openpanel_chart_range');
    store = await LocalStore.open(hiveDir: dir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  final project = ProjectConfig(
    id: 'p1',
    name: 'P',
    baseUrl: 'https://x.test',
    projectId: 'proj',
    createdAt: DateTime(2026, 1, 1),
  );

  test('lastMonth charts carry the resolved month bounds, not a range token', () async {
    final api = _RecordingApi();
    final repo = OverviewRepository(api, project, store);
    final range = const SelectedDateRange.preset(DateRangePreset.lastMonth);

    // Chart fetch fires two series requests then parses; swallow the parse on
    // the stub body — we only assert the captured queries.
    try {
      await repo.fetchVisitorsChart(range);
    } on Object catch (_) {}

    expect(api.captured, isNotEmpty);
    final (s, e) = range.bounds;
    for (final q in api.captured) {
      expect(q['range'], 'custom');
      // Exact ISO datetimes export/charts expects, derived from the model's own
      // bounds so the test locks the wiring rather than a hard-coded month.
      expect(q['startDate'], '${SelectedDateRange.ymd(s)}T00:00:00');
      expect(q['endDate'], '${SelectedDateRange.ymd(e)}T23:59:59');
    }
  });

  test(
    'a rolling preset chart sends its range token with no explicit dates',
    () async {
      final api = _RecordingApi();
      final repo = OverviewRepository(api, project, store);

      try {
        await repo.fetchVisitorsChart(
          const SelectedDateRange.preset(DateRangePreset.last7Days),
        );
      } on Object catch (_) {}

      expect(api.captured, isNotEmpty);
      for (final q in api.captured) {
        expect(q['range'], '7d');
        expect(q.containsKey('startDate'), isFalse);
      }
    },
  );
}
