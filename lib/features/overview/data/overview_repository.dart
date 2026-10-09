import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/date_range.dart';
import '../../../core/models/project_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/export_charts.dart';
import '../../../core/providers.dart';
import '../../../core/storage/local_store.dart';
import 'overview_models.dart';

part 'overview_repository.g.dart';

class OverviewRepository {
  OverviewRepository(this._api, this._project, this._store);

  final OpenPanelApi _api;
  final ProjectConfig _project;
  final LocalStore _store;

  /// KPIs for the window and the window before it.
  /// `GET /insights/{projectId}/metrics` — the exact aggregation the
  /// dashboard overview uses (sessions table, project timezone).
  Future<OverviewMetrics> fetchMetrics(SelectedDateRange range) async {
    final cacheKey = 'metrics:${_project.id}:${range.cacheIdentity}';
    try {
      final path = ApiConstants.insightsMetrics(_project.projectId);
      // The previous window is the comparison, not the headline number. An
      // older server that rejects the explicit startDate/endDate pair, or
      // rate-limits the second request, must not blank the current window the
      // first request already returned — it loses only the "% vs previous".
      final results = await Future.wait([
        _api.get(path, query: range.toQuery()),
        _api
            .get(path, query: range.toPreviousQuery())
            .then<dynamic>((b) => b, onError: (_, _) => null),
      ]);
      final current = _snapshot(results[0]);
      if (current == null) {
        // Zeros here are indistinguishable from "your site is dead", and the
        // zeros get cached and replayed offline as fact. Refuse to invent them.
        throw const ApiException(
          ApiErrorKind.unknown,
          'This server answered the metrics request in a shape this app can\'t '
          'read. Nothing is shown rather than guessing zero.',
        );
      }
      final metrics = OverviewMetrics(
        current: current,
        previous: _snapshot(results[1]),
      );
      await _store.writeCache(cacheKey, jsonEncode(metrics.toJson()));
      return metrics;
    } on ApiException catch (e) {
      final cached = _store.readCache(cacheKey);
      if (cached != null &&
          (e.kind == ApiErrorKind.network || e.kind == ApiErrorKind.timeout)) {
        return OverviewMetrics.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        ).copyWith(fromCache: true);
      }
      rethrow;
    }
  }

  /// Visitors + pageviews over time from `GET /export/charts`.
  Future<VisitorsChart> fetchVisitorsChart(SelectedDateRange range) async {
    Map<String, dynamic> query(String segment) => {
      'projectId': _project.projectId,
      'interval': range.interval,
      'previous': true,
      'series': jsonEncode([
        {'name': 'screen_view', 'segment': segment},
      ]),
      ..._chartRange(range),
    };
    final results = await Future.wait([
      _api.get(ApiConstants.exportCharts, query: query('user')),
      _api.get(ApiConstants.exportCharts, query: query('event')),
    ]);
    return VisitorsChart(
      visitors: _firstSeries(results[0]),
      pageviews: _firstSeries(results[1]),
      interval: range.interval,
    );
  }

  /// export/charts parses startDate/endDate as ISO datetimes.
  static Map<String, dynamic> _chartRange(SelectedDateRange range) {
    if (!range.needsExplicitBounds) {
      return {'range': range.preset.apiRange};
    }
    final (s, e) = range.bounds;
    return {
      'range': 'custom',
      'startDate': '${SelectedDateRange.ymd(s)}T00:00:00',
      'endDate': '${SelectedDateRange.ymd(e)}T23:59:59',
    };
  }

  /// Null means "not a metrics payload", which the caller must not turn into
  /// zeros.
  static MetricsSnapshot? _snapshot(dynamic body) {
    if (body is! Map) return null;
    final metrics = body['metrics'];
    if (metrics is Map) {
      return MetricsSnapshot.fromApi(Map<String, dynamic>.from(metrics));
    }
    final summary = body['summary'];
    if (summary is Map) {
      return MetricsSnapshot.fromApi(Map<String, dynamic>.from(summary));
    }
    return null;
  }
}

/// Maps the first series of an `/export/charts` response into view points.
/// Bucket dates stay project-local — see [parseExportCharts].
List<ChartData> _firstSeries(dynamic body) {
  final series = parseExportCharts(body).firstOrNull;
  if (series == null) return const [];
  final label = series.label;
  return [
    for (final p in series.points)
      ChartData(
        date: p.date,
        count: p.count,
        previous: p.previous,
        breakdown: label,
      ),
  ];
}

@riverpod
Future<OverviewRepository?> overviewRepository(Ref ref) async {
  final project = ref.watch(activeProjectProvider);
  if (project == null) return null;
  // Throws ApiException.noCredentials when the secret isn't on this device.
  final api = await ref.watch(activeApiProvider.future);
  return OverviewRepository(api!, project, ref.watch(localStoreProvider));
}

@riverpod
Future<OverviewMetrics?> overviewMetrics(Ref ref) async {
  final repo = await ref.watch(overviewRepositoryProvider.future);
  if (repo == null) throwNoProject();
  final range = ref.watch(dateRangeSelectionProvider);
  return repo.fetchMetrics(range);
}

@riverpod
Future<VisitorsChart?> visitorsChart(Ref ref) async {
  final repo = await ref.watch(overviewRepositoryProvider.future);
  if (repo == null) throwNoProject();
  final range = ref.watch(dateRangeSelectionProvider);
  return repo.fetchVisitorsChart(range);
}
