import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.change,
    this.invertChange = false,
    this.onTap,
    this.selected = false,
  });

  final String label;
  final String value;
  final IconData icon;

  /// % change vs previous period.
  final double? change;

  /// For metrics where lower is better (bounce rate).
  final bool invertChange;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = change;
    // Anything that renders as "0.0%" is flat, not up. Treating 0.0 as
    // non-negative coloured a no-change day green with an upward arrow.
    final isFlat = c != null && c.abs() < 0.05;
    final good = c == null || isFlat
        ? null
        : invertChange
        ? c < 0
        : c > 0;
    final color = good == null
        ? AppColors.textMuted
        : good
        ? AppColors.positive
        : AppColors.negative;

    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.accentSoft : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: t.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Row(
            children: [
              if (c != null) ...[
                Icon(
                  isFlat
                      ? Icons.remove_rounded
                      : c > 0
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 2),
                Text(
                  '${c.abs().toStringAsFixed(1)}%',
                  style: t.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'vs prev.',
                    overflow: TextOverflow.ellipsis,
                    style: t.labelSmall?.copyWith(color: AppColors.textMuted),
                  ),
                ),
              ] else
                Text(
                  'No previous data',
                  style: t.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
