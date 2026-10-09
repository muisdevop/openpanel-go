import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/coerce.dart';

part 'overview_models.freezed.dart';
part 'overview_models.g.dart';

/// Session-based KPIs, same numbers as the dashboard overview.
@freezed
abstract class MetricsSnapshot with _$MetricsSnapshot {
  const factory MetricsSnapshot({
    @Default(0) double uniqueVisitors,
    @Default(0) double totalSessions,
    @Default(0) double totalScreenViews,
    @Default(0) double bounceRate,
    @Default(0) double avgSessionDuration,
    @Default(0) double viewsPerSession,
  }) = _MetricsSnapshot;

  factory MetricsSnapshot.fromJson(Map<String, dynamic> json) =>
      _$MetricsSnapshotFromJson(json);

  /// Maps the API's snake_case `metrics` object.
  factory MetricsSnapshot.fromApi(Map<String, dynamic> m) {
    return MetricsSnapshot(
      uniqueVisitors: asDouble(m['unique_visitors']),
      totalSessions: asDouble(m['total_sessions']),
      totalScreenViews: asDouble(m['total_screen_views']),
      bounceRate: asDouble(m['bounce_rate']),
      avgSessionDuration: asDouble(m['avg_session_duration']),
      viewsPerSession: asDouble(m['views_per_session']),
    );
  }
}

@freezed
abstract class OverviewMetrics with _$OverviewMetrics {
  const factory OverviewMetrics({
    required MetricsSnapshot current,
    MetricsSnapshot? previous,
    @Default(false) bool fromCache,
  }) = _OverviewMetrics;

  factory OverviewMetrics.fromJson(Map<String, dynamic> json) =>
      _$OverviewMetricsFromJson(json);
}

/// One bucket of a time series (`/export/charts` → series[].data[]).
@freezed
abstract class ChartData with _$ChartData {
  const factory ChartData({
    required DateTime date,
    required double count,
    double? previous,
    String? breakdown,
  }) = _ChartData;

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);
}

@freezed
abstract class VisitorsChart with _$VisitorsChart {
  const factory VisitorsChart({
    @Default([]) List<ChartData> visitors,
    @Default([]) List<ChartData> pageviews,
    @Default('day') String interval,
  }) = _VisitorsChart;

  factory VisitorsChart.fromJson(Map<String, dynamic> json) =>
      _$VisitorsChartFromJson(json);
}
