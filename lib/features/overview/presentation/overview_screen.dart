import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/date_range.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/polling.dart';
import '../../../shared/widgets/project_header.dart';
import '../../shell/home_shell.dart';
import '../data/overview_models.dart';
import '../data/overview_repository.dart';
import 'widgets/kpi_card.dart';
import 'widgets/visitors_chart.dart';

class OverviewScreen extends ConsumerStatefulWidget {
  const OverviewScreen({super.key});

  @override
  ConsumerState<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen>
    with PollingMixin {
  final _refresh = RefreshController();
  DateTime? _updatedAt;

  @override
  Duration get pollInterval => ApiConstants.overviewRefreshInterval;

  @override
  void initState() {
    super.initState();
    startPolling();
  }

  @override
  bool shouldPoll() => shellBranchIsActive(context, 0);

  @override
  Future<void> onTick() async {
    await _reload();
  }

  /// Returns whether the pull-to-refresh spinner should report success.
  ///
  /// `invalidate` returns before the request finishes, which defeated the
  /// mixin's re-entrancy guard and let ticks stack up on a slow server.
  Future<bool> _reload() async {
    try {
      await Future.wait([
        ref.refresh(overviewMetricsProvider.future),
        ref.refresh(visitorsChartProvider.future),
      ]);
      return true;
    } on ApiException catch (e) {
      // The provider already holds the error for the cards to display; the
      // gesture only needs to know whether to show a failed spinner.
      return e.isSilent;
    } catch (_) {
      // A `StateError` from a container disposed under the refresh, or anything
      // the repositories didn't wrap. Only `on ApiException` used to be caught
      // here, so the rest escaped through `onTick` into the zone — the spinner
      // never resolved and the failure left no trace on screen.
      return false;
    }
  }

  Future<void> _onRefresh() async {
    final ok = await _reload();
    if (!mounted) return;
    if (ok) {
      _refresh.refreshCompleted();
    } else {
      _refresh.refreshFailed();
    }
  }

  @override
  void dispose() {
    _refresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(overviewMetricsProvider);
    final chart = ref.watch(visitorsChartProvider);
    ref.listen(overviewMetricsProvider, (_, next) {
      if (next.hasValue && !next.isLoading) {
        setState(() => _updatedAt = DateTime.now());
      }
    });

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
        header: const ClassicHeader(
          refreshingText: 'Refreshing…',
          completeText: 'Up to date',
          idleText: 'Pull to refresh',
          releaseText: 'Release to refresh',
          textStyle: TextStyle(color: AppColors.textSecondary),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            metrics.when(
              skipLoadingOnRefresh: true,
              loading: () => _kpiGrid(null),
              error: (e, _) => SizedBox(
                height: 420,
                child: ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(overviewMetricsProvider),
                ),
              ),
              data: (m) => m == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (m.fromCache) _staleBanner(context),
                        _kpiGrid(m),
                        if (m.previous != null) _comparisonNote(),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            if (!metrics.hasError)
              chart.when(
                skipLoadingOnRefresh: true,
                loading: () => const ChartSkeleton(),
                error: (e, _) => ErrorView(
                  error: e,
                  compact: true,
                  onRetry: () => ref.invalidate(visitorsChartProvider),
                ),
                data: (c) => c == null
                    ? const SizedBox.shrink()
                    : VisitorsChartCard(chart: c),
              ),
            const SizedBox(height: 16),
            if (_updatedAt != null)
              Center(
                child: Text(
                  'Updated ${DateFormat.Hms().format(_updatedAt!)} · auto-refreshes every 60s',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _staleBanner(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        const Icon(Icons.cloud_off_rounded, size: 16, color: AppColors.warning),
        const SizedBox(width: 8),
        Text(
          'Offline · showing last saved numbers',
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: AppColors.warning),
        ),
      ],
    ),
  );

  /// The "% vs previous" figures compare against a window this app computes in
  /// the device's calendar, while the server resolves the current preset in the
  /// project's timezone. Far enough from the project's zone those differ by a
  /// day, so the screen states which window was compared rather than implying
  /// it is the dashboard's own.
  Widget _comparisonNote() {
    final range = ref.watch(dateRangeSelectionProvider);
    if (range.preset == DateRangePreset.custom) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        'Compared to ${range.previousLabel}',
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: AppColors.textMuted),
      ),
    );
  }

  Widget _kpiGrid(OverviewMetrics? m) {
    final cur = m?.current;
    final prev = m?.previous;
    final cards = cur == null
        ? List.generate(6, (_) => const KpiSkeleton())
        : <Widget>[
            KpiCard(
              label: 'Unique visitors',
              icon: Icons.person_outline_rounded,
              value: Fmt.compact(cur.uniqueVisitors),
              change: Fmt.change(cur.uniqueVisitors, prev?.uniqueVisitors),
            ),
            KpiCard(
              label: 'Sessions',
              icon: Icons.timelapse_rounded,
              value: Fmt.compact(cur.totalSessions),
              change: Fmt.change(cur.totalSessions, prev?.totalSessions),
            ),
            KpiCard(
              label: 'Pageviews',
              icon: Icons.visibility_outlined,
              value: Fmt.compact(cur.totalScreenViews),
              change: Fmt.change(cur.totalScreenViews, prev?.totalScreenViews),
            ),
            KpiCard(
              label: 'Bounce rate',
              icon: Icons.u_turn_left_rounded,
              value: Fmt.percent(cur.bounceRate),
              change: Fmt.change(cur.bounceRate, prev?.bounceRate),
              invertChange: true,
            ),
            KpiCard(
              label: 'Visit duration',
              icon: Icons.schedule_rounded,
              value: Fmt.duration(cur.avgSessionDuration),
              change: Fmt.change(
                cur.avgSessionDuration,
                prev?.avgSessionDuration,
              ),
            ),
            KpiCard(
              label: 'Views / session',
              icon: Icons.layers_outlined,
              value: cur.viewsPerSession.toStringAsFixed(2),
              change: Fmt.change(cur.viewsPerSession, prev?.viewsPerSession),
            ),
          ];
    // The cell height came from a fixed aspect ratio, so it never grew with
    // the OS text scale: at ~1.5x the label, value and change rows exceeded
    // the cell and all six cards painted overflow stripes at once. Deriving the
    // ratio from the scaler gives the column the same extra height the text
    // takes.
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55 / scale,
      children: cards,
    );
  }
}
