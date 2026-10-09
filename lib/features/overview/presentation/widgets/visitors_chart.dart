import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../data/overview_models.dart';

enum ChartMetric { visitors, pageviews }

/// Line chart of visitors or pageviews, with the previous period dashed.
class VisitorsChartCard extends StatefulWidget {
  const VisitorsChartCard({super.key, required this.chart});

  final VisitorsChart chart;

  @override
  State<VisitorsChartCard> createState() => _VisitorsChartCardState();
}

class _VisitorsChartCardState extends State<VisitorsChartCard> {
  ChartMetric _metric = ChartMetric.visitors;
  bool _showPrevious = true;

  List<ChartData> get _points => _metric == ChartMetric.visitors
      ? widget.chart.visitors
      : widget.chart.pageviews;

  /// A drawn line is opaque to TalkBack/VoiceOver. Without this the entire
  /// traffic series announces as the words "Visitors over time", which is the
  /// one screen a low-vision user most needs the numbers from.
  String _seriesSummary(List<ChartData> points, bool hourly) {
    final metric = _metric == ChartMetric.visitors ? 'Visitors' : 'Pageviews';
    if (points.isEmpty) return '$metric: no data in this range';
    final f = hourly ? DateFormat.Hm() : DateFormat.MMMd();
    var peak = points.first;
    for (final p in points) {
      if (p.count > peak.count) peak = p;
    }
    final total = points.fold<double>(0, (a, p) => a + p.count);
    return '$metric, ${points.length} ${hourly ? 'hourly' : 'daily'} points, '
        '${Fmt.compact(total)} total, peak ${Fmt.compact(peak.count)} on '
        '${f.format(peak.date)}, from ${f.format(points.first.date)} to '
        '${f.format(points.last.date)}';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final points = _points;
    final hourly = widget.chart.interval == 'hour';
    final total = points.fold<double>(0, (a, p) => a + p.count);
    final hasPrev = points.any((p) => p.previous != null);

    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _metric == ChartMetric.visitors
                          ? 'Visitors over time'
                          : 'Pageviews over time',
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _metric == ChartMetric.visitors
                          ? 'Unique users per ${hourly ? 'hour' : 'day'}'
                          : '${Fmt.compact(total)} screen views',
                      style: t.labelSmall?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              SegmentedButton<ChartMetric>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: t.labelSmall,
                ),
                segments: const [
                  ButtonSegment(
                    value: ChartMetric.visitors,
                    label: Text('Visitors'),
                  ),
                  ButtonSegment(
                    value: ChartMetric.pageviews,
                    label: Text('Views'),
                  ),
                ],
                selected: {_metric},
                onSelectionChanged: (s) => setState(() => _metric = s.first),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Semantics(
            label: _seriesSummary(points, hourly),
            child: SizedBox(
              height: 210,
              child: points.isEmpty
                  ? Center(
                      child: Text(
                        'No data in this range',
                        style: t.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  : LineChart(
                      _data(points, hourly),
                      duration: const Duration(milliseconds: 250),
                    ),
            ),
          ),
          if (hasPrev)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => setState(() => _showPrevious = !_showPrevious),
                icon: Icon(
                  _showPrevious
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 18,
                ),
                label: const Text('Compare to previous period'),
              ),
            ),
        ],
      ),
    );
  }

  LineChartData _data(List<ChartData> points, bool hourly) {
    final maxY = points.fold<double>(
      0,
      (m, p) => math.max(m, math.max(p.count, p.previous ?? 0)),
    );
    final niceMax = maxY <= 0 ? 4.0 : (maxY * 1.2).ceilToDouble();
    final step = math.max(1, (points.length / 5).ceil());
    final labelFmt = hourly ? DateFormat.j() : DateFormat.MMMd();
    // Distance between the current window and the previous one. Derived from
    // the requested bucket width and the span the points actually cover — NOT
    // from the gap between the first two points, because the API omits
    // zero-traffic buckets: one such gap multiplied by the point count shifted
    // every "previous period" tooltip date by weeks on a sparse 30-day range.
    final bucket = hourly ? const Duration(hours: 1) : const Duration(days: 1);
    final periodShift =
        (points.length > 1
            ? points.last.date.difference(points.first.date)
            : Duration.zero) +
        bucket;

    LineChartBarData bar(
      List<FlSpot> spots, {
      required Color color,
      bool dashed = false,
      bool fill = false,
    }) => LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.25,
      preventCurveOverShooting: true,
      color: color,
      barWidth: dashed ? 1.5 : 2.5,
      dashArray: dashed ? [4, 4] : null,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: fill,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0.0)],
        ),
      ),
    );

    final current = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].count),
    ];
    final previous = [
      for (var i = 0; i < points.length; i++)
        if (points[i].previous != null)
          FlSpot(i.toDouble(), points[i].previous!),
    ];

    return LineChartData(
      minY: 0,
      maxY: niceMax,
      minX: 0,
      maxX: math.max(0, points.length - 1).toDouble(),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: niceMax / 4,
        getDrawingHorizontalLine: (_) =>
            const FlLine(color: AppColors.border, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            interval: niceMax / 4,
            getTitlesWidget: (v, meta) => SideTitleWidget(
              meta: meta,
              child: Text(
                Fmt.compact(v),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: 1,
            getTitlesWidget: (v, meta) {
              final i = v.toInt();
              if (i < 0 || i >= points.length || i % step != 0) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  labelFmt.format(points[i].date),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.cardHigh,
          tooltipBorderRadius: BorderRadius.circular(10),
          tooltipBorder: const BorderSide(color: AppColors.border),
          fitInsideHorizontally: true,
          getTooltipItems: (spots) => spots.map((s) {
            final i = s.x.round().clamp(0, points.length - 1);
            final p = points[i];
            final isPrev = s.barIndex == 1;
            if (isPrev) {
              // The dashed series shares the x axis with the current one, so a
              // label that only says "Previous" reads as if it belongs to the
              // day being hovered. Name the day it actually came from.
              final then = hourly
                  ? DateFormat('MMM d, HH:mm')
                        .format(p.date.subtract(periodShift))
                  : DateFormat('MMM d').format(p.date.subtract(periodShift));
              return LineTooltipItem(
                '$then\nPrevious: ${Fmt.number(s.y)}',
                const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              );
            }
            final when = hourly
                ? DateFormat('MMM d, HH:mm').format(p.date)
                : DateFormat.yMMMd().format(p.date);
            return LineTooltipItem(
              '$when\n${Fmt.number(s.y)}',
              const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList(),
        ),
      ),
      lineBarsData: [
        bar(current, color: AppColors.accent, fill: true),
        if (_showPrevious && previous.isNotEmpty)
          bar(previous, color: AppColors.textMuted, dashed: true),
      ],
    );
  }
}
