import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../shared/theme/app_theme.dart';
import '../data/event_models.dart';
import 'widgets/event_tile.dart';

Future<void> showEventDetailSheet(BuildContext context, OpenPanelEvent e) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (ctx, scroll) => EventDetailSheet(event: e, scroll: scroll),
    ),
  );
}

class EventDetailSheet extends StatelessWidget {
  const EventDetailSheet({super.key, required this.event, this.scroll});

  final OpenPanelEvent event;
  final ScrollController? scroll;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final e = event;
    final color = eventColor(e.name);
    final props = Map<String, dynamic>.from(e.properties)
      ..removeWhere((k, v) => v == null || (v is String && v.isEmpty));

    return ListView(
      controller: scroll,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Row(
          children: [
            // Flexible: the event name is developer-defined and can easily
            // outgrow the sheet. Unbounded, this Row threw the overflow stripes
            // instead of truncating.
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  e.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Copy as JSON',
              icon: const Icon(Icons.copy_rounded, size: 20),
              onPressed: () async {
                // Taken before the await: the sheet can be dismissed while the
                // clipboard write is in flight, and using `context` afterwards
                // is a use-after-dispose.
                final messenger = ScaffoldMessenger.of(context);
                try {
                  // Awaited — a clipboard write can be rejected by the OS, and
                  // firing it off would report success either way.
                  await Clipboard.setData(
                    ClipboardData(
                      text: const JsonEncoder.withIndent('  ')
                          .convert(e.toShareableJson()),
                    ),
                  );
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Copied — personal details removed'),
                    ),
                  );
                } on Exception {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Couldn't write to the clipboard"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('EEE, MMM d y · HH:mm:ss').format(e.timestamp),
          style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        if (e.path != null) ...[
          const SizedBox(height: 4),
          Text(
            '${e.origin ?? ''}${e.path}',
            style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
        if (e.profile != null || e.isIdentified)
          _Section(
            title: 'Profile',
            icon: Icons.person_rounded,
            rows: [
              ('Name', e.profile?.displayName ?? e.profileId),
              ('Email', e.profile?.email),
              ('Profile ID', e.profileId),
              for (final entry in (e.profile?.properties ?? {}).entries)
                (entry.key, _fmt(entry.value)),
            ],
          ),
        _Section(
          title: 'Location',
          icon: Icons.place_rounded,
          leading: CountryFlagIcon(e.geo.country, width: 22),
          rows: [
            ('Country', e.geo.country),
            ('Region', e.geo.region),
            ('City', e.geo.city),
            if (e.geo.latitude != null && e.geo.longitude != null)
              (
                'Coordinates',
                '${e.geo.latitude!.toStringAsFixed(3)}, ${e.geo.longitude!.toStringAsFixed(3)}',
              ),
          ],
        ),
        _Section(
          title: 'Device',
          icon: deviceIcon(e.device),
          rows: [
            ('Type', e.device.device),
            ('Browser', _join(e.device.browser, e.device.browserVersion)),
            ('OS', _join(e.device.os, e.device.osVersion)),
            ('Model', _join(e.device.brand, e.device.model)),
          ],
        ),
        _Section(
          title: 'Referrer',
          icon: Icons.call_received_rounded,
          rows: [
            ('Source', e.referrer.name),
            ('Type', e.referrer.type),
            ('URL', e.referrer.url),
          ],
        ),
        if (props.isNotEmpty)
          _Section(
            title: 'Properties',
            icon: Icons.data_object_rounded,
            rows: [for (final p in props.entries) (p.key, _fmt(p.value))],
          ),
        _Section(
          title: 'Identifiers',
          icon: Icons.fingerprint_rounded,
          rows: [
            ('Event ID', e.id),
            ('Session ID', e.sessionId),
            ('Device ID', e.deviceId),
            if (e.duration != null && e.duration! > 0)
              ('Duration', '${(e.duration! / 1000).toStringAsFixed(1)}s'),
            ('SDK', _join(e.sdkName, e.sdkVersion)),
          ],
        ),
      ],
    );
  }

  static String? _join(String? a, String? b) {
    final parts = [a, b].where((s) => s != null && s.isNotEmpty).toList();
    return parts.isEmpty ? null : parts.join(' ');
  }

  static String _fmt(Object? v) {
    if (v is Map || v is List) return jsonEncode(v);
    return '$v';
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.rows,
    this.leading,
  });

  final String title;
  final IconData icon;
  final List<(String, String?)> rows;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final visible = rows
        .where((r) => r.$2 != null && r.$2!.isNotEmpty)
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: t.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              ?leading,
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                for (var i = 0; i < visible.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 110,
                          child: Text(
                            visible[i].$1,
                            style: t.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SelectableText(
                            visible[i].$2!,
                            style: t.bodySmall?.copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
