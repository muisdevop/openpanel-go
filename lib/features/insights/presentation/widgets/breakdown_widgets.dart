import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../realtime/presentation/widgets/event_tile.dart';
import '../../data/insights_repository.dart';

double _total(List<BreakdownItem> items) =>
    items.fold<double>(0, (a, b) => a + b.sessions);

/// Collapses everything after [n] into an "Other" bucket.
List<BreakdownItem> topN(List<BreakdownItem> items, int n) {
  if (items.length <= n) return items;
  final rest = items.skip(n);
  return [
    ...items.take(n),
    BreakdownItem(
      label: 'Other',
      sessions: rest.fold(0, (a, b) => a + b.sessions),
      pageviews: rest.fold(0, (a, b) => a + b.pageviews),
    ),
  ];
}

/// Rows with an inline proportional bar. Used for pages, browsers, OS.
class BarList extends StatelessWidget {
  const BarList({
    super.key,
    required this.items,
    this.max = 6,
    this.leading,
    this.valueOf,
    this.onTapItem,
  });

  final List<BreakdownItem> items;
  final int max;
  final Widget Function(BreakdownItem)? leading;
  final double Function(BreakdownItem)? valueOf;
  final void Function(BreakdownItem)? onTapItem;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final v = valueOf ?? (BreakdownItem i) => i.sessions;
    final shown = items.take(max).toList();
    final top = shown.isEmpty ? 1.0 : shown.map(v).reduce(math.max);
    return Column(
      children: [
        for (final item in shown)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTapItem == null ? null : () => onTapItem!(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: top <= 0
                          ? 0
                          : (v(item) / top).clamp(0.02, 1),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 9,
                    ),
                    child: Row(
                      children: [
                        if (leading != null) ...[
                          leading!(item),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodySmall,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Fmt.compact(v(item)),
                          style: t.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Vertical bar chart of the top referrers.
class ReferrerBarChart extends StatefulWidget {
  const ReferrerBarChart({super.key, required this.items, this.onTapItem});

  final List<BreakdownItem> items;
  final void Function(BreakdownItem)? onTapItem;

  @override
  State<ReferrerBarChart> createState() => _ReferrerBarChartState();
}

class _ReferrerBarChartState extends State<ReferrerBarChart> {
  int? _touched;

  /// The bars are unreadable to a screen reader; this spells the same data out.
  String _summary(List<BreakdownItem> items) {
    if (items.isEmpty) return 'Top referrers: no data in this range';
    return 'Top referrers: '
        '${items.map((e) => '${e.label}, ${Fmt.number(e.sessions)} sessions').join('; ')}';
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items.take(6).toList();
    final maxY = items.isEmpty
        ? 1.0
        : items.map((e) => e.sessions).reduce(math.max) * 1.2;
    return Semantics(
      label: _summary(items),
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            maxY: maxY <= 0 ? 1 : maxY,
            alignment: BarChartAlignment.spaceAround,
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: maxY <= 0 ? 1 : maxY / 4,
              getDrawingHorizontalLine: (_) =>
                  const FlLine(color: AppColors.border, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  interval: maxY <= 0 ? 1 : maxY / 4,
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
                  reservedSize: 28,
                  getTitlesWidget: (v, meta) {
                    final i = v.toInt();
                    if (i < 0 || i >= items.length) {
                      return const SizedBox.shrink();
                    }
                    final l = items[i].label;
                    return SideTitleWidget(
                      meta: meta,
                      child: SizedBox(
                        width: 52,
                        child: Text(
                          l,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              touchCallback: (event, resp) {
                final i = resp?.spot?.touchedBarGroupIndex;
                setState(() => _touched = i);
                if (event is FlTapUpEvent && i != null && i < items.length) {
                  widget.onTapItem?.call(items[i]);
                }
              },
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => AppColors.cardHigh,
                tooltipBorder: const BorderSide(color: AppColors.border),
                getTooltipItem: (g, _, rod, _) {
                  // `g.x` is handed back by the chart while it animates between
                  // two different `items` lists; an index past the end of the
                  // new list used to throw a RangeError on tap.
                  final i = g.x.clamp(0, items.length - 1);
                  return BarTooltipItem(
                    '${items[i].label}\n${Fmt.number(rod.toY)} sessions',
                    const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            barGroups: [
              for (var i = 0; i < items.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: items[i].sessions,
                      width: 22,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: _touched == i
                            ? const [AppColors.accentSoft, Color(0xFFA78BFA)]
                            : const [AppColors.accent, Color(0xFF8B5CF6)],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          duration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }
}

/// Pie (or donut when [donut]) with a legend.
class BreakdownPie extends StatefulWidget {
  const BreakdownPie({
    super.key,
    required this.items,
    this.donut = false,
    this.flags = false,
    this.icons = false,
    this.onTapItem,
  });

  final List<BreakdownItem> items;
  final bool donut;
  final bool flags;
  final bool icons;
  final void Function(BreakdownItem)? onTapItem;

  @override
  State<BreakdownPie> createState() => _BreakdownPieState();
}

class _BreakdownPieState extends State<BreakdownPie> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final items = topN(widget.items, 5);
    final total = _total(items);
    Color color(int i) => AppColors.chart[i % AppColors.chart.length];

    return Row(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // fl_chart divides every slice by the total, so an all-zero list
              // would yield NaN angles. Skip the pie and let the legend carry
              // the "–" shares instead of inventing slivers for it.
              if (total > 0)
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: widget.donut ? 42 : 0,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, resp) {
                        final i =
                            resp?.touchedSection?.touchedSectionIndex ?? -1;
                        setState(() => _touched = i);
                        if (event is FlTapUpEvent &&
                            i >= 0 &&
                            i < items.length) {
                          widget.onTapItem?.call(items[i]);
                        }
                      },
                    ),
                    sections: [
                      for (var i = 0; i < items.length; i++)
                        PieChartSectionData(
                          value: items[i].sessions,
                          color: color(i),
                          showTitle: false,
                          radius:
                              (widget.donut ? 24 : 64) +
                              (_touched == i ? 6 : 0),
                        ),
                    ],
                  ),
                  duration: const Duration(milliseconds: 250),
                ),
              if (widget.donut)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Fmt.compact(total),
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'sessions',
                      style: t.labelSmall?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: widget.onTapItem == null
                      ? null
                      : () => widget.onTapItem!(items[i]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color(i),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.flags && items[i].label != 'Other') ...[
                          CountryFlagIcon(items[i].label, width: 16),
                          const SizedBox(width: 6),
                        ],
                        if (widget.icons) ...[
                          Icon(
                            _deviceIcon(items[i].label),
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            items[i].label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodySmall?.copyWith(
                              fontWeight: _touched == i
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          total <= 0
                              ? '–'
                              : '${(items[i].sessions / total * 100).toStringAsFixed(0)}%',
                          style: t.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static IconData _deviceIcon(String l) => switch (l.toLowerCase()) {
    'mobile' => Icons.smartphone_rounded,
    'tablet' => Icons.tablet_mac_rounded,
    'desktop' => Icons.desktop_windows_rounded,
    _ => Icons.devices_other_rounded,
  };
}
