import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../shared/theme/app_theme.dart';
import '../../data/event_models.dart';

Color eventColor(String name) {
  if (name == 'screen_view') return AppColors.accent;
  if (name == 'session_start') return AppColors.positive;
  if (name == 'session_end') return AppColors.textMuted;
  return AppColors.chart[name.hashCode.abs() % AppColors.chart.length];
}

IconData deviceIcon(EventDevice d) => switch (d.kind) {
  'mobile' => Icons.smartphone_rounded,
  'tablet' => Icons.tablet_mac_rounded,
  'desktop' => Icons.desktop_windows_rounded,
  _ => Icons.devices_other_rounded,
};

class CountryFlagIcon extends StatelessWidget {
  const CountryFlagIcon(this.code, {super.key, this.width = 20});
  final String? code;
  final double width;

  @override
  Widget build(BuildContext context) {
    final c = code;
    // Every call site pairs the flag with the country code or a place name as
    // text. Left unexcluded, TalkBack reads the regional-indicator glyph as
    // "U S" on top of that label, so the picture is decoration, not content.
    return ExcludeSemantics(
      child: c == null || c.length != 2
          ? Icon(
              Icons.public_rounded,
              size: width * 0.85,
              color: AppColors.textMuted,
            )
          : CountryFlag.fromCountryCode(
              c,
              theme: ImageTheme(
                width: width,
                height: width * 0.7,
                shape: const RoundedRectangle(3),
              ),
            ),
    );
  }
}

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.onTap,
    this.fresh = false,
  });

  final OpenPanelEvent event;
  final VoidCallback onTap;
  final bool fresh;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final color = eventColor(event.name);
    final subtitle =
        event.path ??
        event.properties['__path']?.toString() ??
        event.referrer.name ??
        event.origin ??
        '';
    return TweenAnimationBuilder<double>(
      key: ValueKey(event.id),
      tween: Tween(begin: fresh ? 1 : 0, end: 0),
      duration: const Duration(milliseconds: 1600),
      builder: (context, v, child) => Container(
        color: AppColors.accent.withValues(alpha: 0.12 * v),
        child: child,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.cardHigh,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(
                  deviceIcon(event.device),
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: color.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              event.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.labelSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        if (event.isIdentified) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_user_rounded,
                            size: 14,
                            color: AppColors.accentSoft,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle.isEmpty ? '—' : subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CountryFlagIcon(event.geo.country),
                  const SizedBox(height: 6),
                  Text(
                    timeago.format(event.timestamp, locale: 'en_short'),
                    style: t.labelSmall?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
