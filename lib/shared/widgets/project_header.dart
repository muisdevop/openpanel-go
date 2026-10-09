import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/date_range.dart';
import '../../core/providers.dart';
import '../../core/utils/formatters.dart';
import '../theme/app_theme.dart';

/// Tappable project name that opens a switcher sheet.
class ProjectSelector extends ConsumerWidget {
  const ProjectSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(activeProjectProvider);
    final t = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: () => showProjectSwitcher(context),
      child: Padding(
        // 26px avatar + 8px of padding was a ~34dp target, under the 48dp
        // minimum for a control this central.
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                // Characters, not name[0]: a project named with an emoji or
                // other non-BMP character showed half a code unit.
                (project?.name.isNotEmpty ?? false)
                    ? Characters(project!.name).first.toString().toUpperCase()
                    : '?',
                style: t.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                project?.name ?? 'No project',
                overflow: TextOverflow.ellipsis,
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(
              Icons.unfold_more_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showProjectSwitcher(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => Consumer(
      builder: (ctx, ref, _) {
        final projects = ref.watch(projectsProvider);
        final activeId = ref.watch(activeProjectProvider)?.id;
        return SafeArea(
          // A project list longer than the sheet used to overflow it and paint
          // a yellow stripe instead of scrolling.
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    'Projects',
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                ),
                for (final p in projects)
                  ListTile(
                    leading: Icon(
                      p.id == activeId
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: p.id == activeId ? AppColors.accent : null,
                    ),
                    title: Text(p.name),
                    subtitle: Text(
                      '${p.projectId} · ${urlHost(p.baseUrl)}',
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                    onTap: () {
                      // `select` never throws: it swallows its own persistence
                      // failure after applying the in-memory selection.
                      unawaited(
                        ref.read(activeProjectIdProvider.notifier).select(p.id),
                      );
                      Navigator.of(ctx).pop();
                    },
                  ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.add_rounded),
                  title: const Text('Add project'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // Completes when the pushed route is popped; nothing
                    // observes it, and go_router surfaces route errors itself.
                    unawaited(context.push('/login'));
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

/// Horizontal chips: Today · Yesterday · 7d · 30d · Custom.
class DateRangeBar extends ConsumerWidget {
  const DateRangeBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(dateRangeSelectionProvider);
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final preset in DateRangePreset.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                showCheckmark: false,
                avatar: preset == DateRangePreset.custom
                    ? const Icon(Icons.calendar_today_rounded, size: 14)
                    : null,
                label: Text(
                  preset == DateRangePreset.custom &&
                          range.preset == DateRangePreset.custom
                      ? range.label
                      : preset.label,
                ),
                selected: range.preset == preset,
                selectedColor: AppColors.accent.withValues(alpha: 0.22),
                onSelected: (_) async {
                  if (preset != DateRangePreset.custom) {
                    await ref
                        .read(dateRangeSelectionProvider.notifier)
                        .set(SelectedDateRange.preset(preset));
                    return;
                  }
                  final now = DateTime.now();
                  final (s, e) = range.bounds;
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(now.year - 3),
                    lastDate: now,
                    initialDateRange: DateTimeRange(start: s, end: e),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        datePickerTheme: const DatePickerThemeData(
                          backgroundColor: AppColors.card,
                          rangeSelectionBackgroundColor: Color(0x333B82F6),
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked == null) return;
                  // The picker is a route: this chip can be gone by the time it
                  // returns, and touching a disposed ref there throws.
                  if (!context.mounted) return;
                  await ref
                      .read(dateRangeSelectionProvider.notifier)
                      .set(
                        SelectedDateRange(
                          DateRangePreset.custom,
                          customStart: picked.start,
                          customEnd: picked.end,
                        ),
                      );
                },
              ),
            ),
        ],
      ),
    );
  }
}
