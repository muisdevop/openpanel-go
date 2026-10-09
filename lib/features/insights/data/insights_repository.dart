import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/date_range.dart';
import '../../../core/models/project_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/export_charts.dart';
import '../../../core/providers.dart';
import '../../../core/utils/coerce.dart';

part 'insights_repository.g.dart';

enum Breakdown {
  referrers('referrer_name', 'Top referrers', 'referrer_name'),
  pages('pages', 'Top pages', 'path'),
  countries('country', 'Countries', 'country'),
  devices('device', 'Devices', 'device'),
  browsers('browser', 'Browsers', 'browser'),
  os('os', 'Operating systems', 'os');

  const Breakdown(this.insightsColumn, this.title, this.eventProperty);

  /// `/insights/{projectId}/{column}`.
  final String insightsColumn;
  final String title;

  /// Event property used for the `/export/charts` breakdown fallback.
  final String eventProperty;
}

class BreakdownItem {
  const BreakdownItem({
    required this.label,
    required this.sessions,
    required this.pageviews,
    this.prefix,
  });

  final String label;
  final String? prefix;
  final double sessions;
  final double pageviews;
}

class InsightsRepository {
  InsightsRepository(this._api, this._project);

  final OpenPanelApi _api;
  final ProjectConfig _project;

  /// Tries the Insights API first (session-based, matches the dashboard),
  /// then falls back to `/export/charts` with `breakdowns` for older
  /// self-hosted servers that don't ship `/insights`.
  ///
  /// Older servers answer the un-known column with 404 *or* 400 depending on
  /// the build, so both trigger the fallback; anything else (401/403/429) is a
  /// real error and must not be masked by a second request.
  Future<List<BreakdownItem>> fetch(
    Breakdown b,
    SelectedDateRange range,
  ) async {
    try {
      final items = await _fromInsights(b, range);
      if (items != null) return items;
      // else: the route answered but the body isn't a row list. Fall through to
      // the breakdowns endpoint rather than rendering "No data in this range"
      // for a server that did return data.
    } on ApiException catch (e) {
      if (e.kind != ApiErrorKind.notFound &&
          e.kind != ApiErrorKind.badRequest) {
        rethrow;
      }
    }
    return _fromExportCharts(b, range);
  }

  /// Null when the response isn't recognisable as a list of rows.
  Future<List<BreakdownItem>?> _fromInsights(
    Breakdown b,
    SelectedDateRange range,
  ) async {
    final path = b == Breakdown.pages
        ? ApiConstants.insightsPages(_project.projectId)
        : ApiConstants.insightsColumn(_project.projectId, b.insightsColumn);
    final body = await _api.get(path, query: range.toQuery());
    final rows = switch (body) {
      final List l => l,
      final Map m when m['data'] is List => m['data'] as List,
      _ => null,
    };
    if (rows == null) return null;
    final items = <BreakdownItem>[];
    for (final r in rows) {
      if (r is! Map) continue;
      final label = b == Breakdown.pages
          ? (r['path']?.toString() ?? '')
          : (r['name']?.toString() ?? '');
      items.add(
        BreakdownItem(
          label: label.isEmpty ? '(not set)' : label,
          prefix: b == Breakdown.pages
              ? r['origin']?.toString()
              : r['prefix']?.toString(),
          sessions: asDouble(r['sessions']),
          pageviews: asDouble(r['pageviews']),
        ),
      );
    }
    items.sort((a, b) => b.sessions.compareTo(a.sessions));
    return items;
  }

  Future<List<BreakdownItem>> _fromExportCharts(
    Breakdown b,
    SelectedDateRange range,
  ) async {
    final eventName = b == Breakdown.pages ? 'screen_view' : 'session_start';
    final (start, end) = range.bounds;
    final body = await _api.get(
      ApiConstants.exportCharts,
      query: {
        'projectId': _project.projectId,
        'interval': 'day',
        'series': jsonEncode([
          {'name': eventName, 'segment': 'event'},
        ]),
        'breakdowns': jsonEncode([
          {'name': b.eventProperty},
        ]),
        if (range.needsExplicitBounds) ...{
          'range': 'custom',
          'startDate': '${SelectedDateRange.ymd(start)}T00:00:00',
          'endDate': '${SelectedDateRange.ymd(end)}T23:59:59',
        } else
          'range': range.preset.apiRange,
      },
    );
    // One series per breakdown value; the count is what this endpoint actually
    // returns, so total the buckets instead of reading a field that isn't there.
    final items = <BreakdownItem>[];
    for (final series in parseExportCharts(body)) {
      final total = series.total;
      if (total <= 0) continue;
      items.add(
        BreakdownItem(
          label: series.label ?? '(not set)',
          // `/export/charts` has no session/pageview split, so the same figure
          // stands in for both. The label column is the part that's exact.
          sessions: total,
          pageviews: total,
        ),
      );
    }
    items.sort((a, b) => b.sessions.compareTo(a.sessions));
    return items;
  }
}

@riverpod
Future<InsightsRepository?> insightsRepository(Ref ref) async {
  final project = ref.watch(activeProjectProvider);
  if (project == null) return null;
  // Throws ApiException(noCredentials) when the secret isn't on this device.
  final api = await ref.watch(activeApiProvider.future);
  return InsightsRepository(api!, project);
}

@riverpod
Future<List<BreakdownItem>> breakdown(Ref ref, Breakdown b) async {
  final repo = await ref.watch(insightsRepositoryProvider.future);
  if (repo == null) throwNoProject();
  final range = ref.watch(dateRangeSelectionProvider);
  return repo.fetch(b, range);
}
