import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/project_header.dart';
import '../../realtime/presentation/widgets/event_tile.dart';
import '../data/insights_repository.dart';
import 'widgets/breakdown_widgets.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  final _refresh = RefreshController();

  @override
  void dispose() {
    _refresh.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    Object? failure;
    try {
      await Future.wait([
        for (final b in Breakdown.values)
          ref.refresh(breakdownProvider(b).future),
      ]);
    } catch (e) {
      failure = e;
    }
    // The controller lives on a State that can be gone by the time six
    // requests come back; completing it after dispose throws.
    if (!mounted) return;
    if (failure == null) {
      _refresh.refreshCompleted();
    } else {
      _refresh.refreshFailed();
    }
  }

  void _openFull(Breakdown b) {
    final items = ref.read(breakdownProvider(b)).value ?? const [];
    // The future completes when the sheet is dismissed; nothing acts on that,
    // and a throwing builder is already reported by the framework.
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (ctx, scroll) =>
              _FullBreakdownList(breakdown: b, items: items, scroll: scroll),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const ProjectSelector(),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: DateRangeBar(),
          ),
        ),
      ),
      body: SmartRefresher(
        controller: _refresh,
        onRefresh: _onRefresh,
        header: const MaterialClassicHeader(color: AppColors.accent),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _card(
              Breakdown.referrers,
              (items) => ReferrerBarChart(
                items: items,
                onTapItem: (_) => _openFull(Breakdown.referrers),
              ),
            ),
            _card(
              Breakdown.pages,
              (items) => BarList(
                items: items,
                max: 7,
                onTapItem: (_) => _openFull(Breakdown.pages),
              ),
            ),
            _card(
              Breakdown.countries,
              (items) => BreakdownPie(
                items: items,
                flags: true,
                onTapItem: (_) => _openFull(Breakdown.countries),
              ),
            ),
            _card(
              Breakdown.devices,
              (items) => BreakdownPie(
                items: items,
                donut: true,
                icons: true,
                onTapItem: (_) => _openFull(Breakdown.devices),
              ),
            ),
            _card(
              Breakdown.browsers,
              (items) => BarList(
                items: items,
                onTapItem: (_) => _openFull(Breakdown.browsers),
              ),
            ),
            _card(
              Breakdown.os,
              (items) => BarList(
                items: items,
                onTapItem: (_) => _openFull(Breakdown.os),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(Breakdown b, Widget Function(List<BreakdownItem>) builder) {
    final async = ref.watch(breakdownProvider(b));
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: async.when(
        skipLoadingOnRefresh: true,
        loading: () => const ChartSkeleton(height: 140),
        error: (e, _) => ErrorView(
          error: e,
          compact: true,
          onRetry: () => ref.invalidate(breakdownProvider(b)),
        ),
        data: (items) => SurfaceCard(
          onTap: items.isEmpty ? null : () => _openFull(b),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    b.title,
                    style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  if (items.isNotEmpty)
                    Text(
                      'See all',
                      style: t.labelMedium?.copyWith(
                        color: AppColors.accentSoft,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No data in this range',
                      style: t.bodySmall?.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                )
              else
                builder(items),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullBreakdownList extends StatelessWidget {
  const _FullBreakdownList({
    required this.breakdown,
    required this.items,
    this.scroll,
  });

  final Breakdown breakdown;
  final List<BreakdownItem> items;
  final ScrollController? scroll;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final total = items.fold<double>(0, (a, b) => a + b.sessions);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: [
              Text(breakdown.title, style: t.titleMedium),
              const Spacer(),
              Text(
                'Sessions',
                style: t.labelSmall?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(width: 24),
              Text(
                'Views',
                style: t.labelSmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            controller: scroll,
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final it = items[i];
              final share = total <= 0 ? 0.0 : it.sessions / total;
              return ListTile(
                dense: true,
                leading: breakdown == Breakdown.countries
                    ? CountryFlagIcon(it.label, width: 22)
                    : Text(
                        '${i + 1}',
                        style: t.labelMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                title: Text(
                  it.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: it.prefix == null || it.prefix!.isEmpty
                    ? null
                    : Text(
                        it.prefix!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                trailing: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${Fmt.compact(it.sessions)} '
                        '(${(share * 100).toStringAsFixed(0)}%)',
                        style: t.labelMedium,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 36,
                        child: Text(
                          Fmt.compact(it.pageviews),
                          textAlign: TextAlign.end,
                          style: t.labelMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
