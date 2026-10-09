import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/core/models/date_range.dart';
import 'package:openpanel_go/core/models/project_config.dart';
import 'package:openpanel_go/core/network/dio_client.dart';
import 'package:openpanel_go/features/insights/data/insights_repository.dart';

/// The insights fallback has the same hand-assembled query as the overview
/// chart path: `_fromExportCharts` builds `range`/`startDate`/`endDate` from
/// `needsExplicitBounds` instead of reusing the model's toQuery(). A regression
/// that drops `lastMonth` there would POST `range=custom` with no dates to a
/// server that only reaches this branch when `/insights` is missing.
///
/// The fallback is only reached when the primary `_fromInsights` call answers
/// with something that isn't a row list, so the stub returns `{}`: that makes
/// `_fromInsights` yield null and fall through. The export/charts request is
/// then identified by its `breakdowns` key.
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
    // {} isn't a row list, so the primary path returns null and the fallback
    // fires; the export/charts parse on this stub body is swallowed by tests.
    return const {};
  }
}

void main() {
  final project = ProjectConfig(
    id: 'p1',
    name: 'P',
    baseUrl: 'https://x.test',
    projectId: 'proj',
    createdAt: DateTime(2026, 1, 1),
  );

  Iterable<Map<String, dynamic>> breakdownQueries(
    List<Map<String, dynamic>> captured,
  ) => captured.where((q) => q.containsKey('breakdowns'));

  test(
    'lastMonth export-charts fallback carries the resolved month bounds',
    () async {
      final api = _RecordingApi();
      final repo = InsightsRepository(api, project);
      final range = const SelectedDateRange.preset(DateRangePreset.lastMonth);

      try {
        await repo.fetch(Breakdown.countries, range);
      } on Object catch (_) {}

      final queries = breakdownQueries(api.captured).toList();
      expect(queries, isNotEmpty);
      final (s, e) = range.bounds;
      for (final q in queries) {
        expect(q['range'], 'custom');
        // Derived from the model's own bounds so this locks the wiring to
        // lastMonth's resolution, not a hard-coded month.
        expect(q['startDate'], '${SelectedDateRange.ymd(s)}T00:00:00');
        expect(q['endDate'], '${SelectedDateRange.ymd(e)}T23:59:59');
      }
    },
  );

  test(
    'a rolling preset export-charts fallback sends its range token only',
    () async {
      final api = _RecordingApi();
      final repo = InsightsRepository(api, project);

      try {
        await repo.fetch(
          Breakdown.countries,
          const SelectedDateRange.preset(DateRangePreset.last7Days),
        );
      } on Object catch (_) {}

      final queries = breakdownQueries(api.captured).toList();
      expect(queries, isNotEmpty);
      for (final q in queries) {
        expect(q['range'], '7d');
        expect(q.containsKey('startDate'), isFalse);
      }
    },
  );
}
