// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MetricsSnapshot _$MetricsSnapshotFromJson(Map<String, dynamic> json) =>
    _MetricsSnapshot(
      uniqueVisitors: (json['uniqueVisitors'] as num?)?.toDouble() ?? 0,
      totalSessions: (json['totalSessions'] as num?)?.toDouble() ?? 0,
      totalScreenViews: (json['totalScreenViews'] as num?)?.toDouble() ?? 0,
      bounceRate: (json['bounceRate'] as num?)?.toDouble() ?? 0,
      avgSessionDuration: (json['avgSessionDuration'] as num?)?.toDouble() ?? 0,
      viewsPerSession: (json['viewsPerSession'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$MetricsSnapshotToJson(_MetricsSnapshot instance) =>
    <String, dynamic>{
      'uniqueVisitors': instance.uniqueVisitors,
      'totalSessions': instance.totalSessions,
      'totalScreenViews': instance.totalScreenViews,
      'bounceRate': instance.bounceRate,
      'avgSessionDuration': instance.avgSessionDuration,
      'viewsPerSession': instance.viewsPerSession,
    };

_OverviewMetrics _$OverviewMetricsFromJson(Map<String, dynamic> json) =>
    _OverviewMetrics(
      current: MetricsSnapshot.fromJson(
        json['current'] as Map<String, dynamic>,
      ),
      previous: json['previous'] == null
          ? null
          : MetricsSnapshot.fromJson(json['previous'] as Map<String, dynamic>),
      fromCache: json['fromCache'] as bool? ?? false,
    );

Map<String, dynamic> _$OverviewMetricsToJson(_OverviewMetrics instance) =>
    <String, dynamic>{
      'current': instance.current,
      'previous': instance.previous,
      'fromCache': instance.fromCache,
    };

_ChartData _$ChartDataFromJson(Map<String, dynamic> json) => _ChartData(
  date: DateTime.parse(json['date'] as String),
  count: (json['count'] as num).toDouble(),
  previous: (json['previous'] as num?)?.toDouble(),
  breakdown: json['breakdown'] as String?,
);

Map<String, dynamic> _$ChartDataToJson(_ChartData instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'count': instance.count,
      'previous': instance.previous,
      'breakdown': instance.breakdown,
    };

_VisitorsChart _$VisitorsChartFromJson(Map<String, dynamic> json) =>
    _VisitorsChart(
      visitors:
          (json['visitors'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pageviews:
          (json['pageviews'] as List<dynamic>?)
              ?.map((e) => ChartData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      interval: json['interval'] as String? ?? 'day',
    );

Map<String, dynamic> _$VisitorsChartToJson(_VisitorsChart instance) =>
    <String, dynamic>{
      'visitors': instance.visitors,
      'pageviews': instance.pageviews,
      'interval': instance.interval,
    };
