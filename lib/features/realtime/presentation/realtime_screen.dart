import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import '../../../shared/widgets/polling.dart';
import '../../../shared/widgets/project_header.dart';
import '../../shell/home_shell.dart';
import '../data/event_models.dart';
import '../data/events_repository.dart';
import 'event_detail_sheet.dart';
import 'widgets/event_tile.dart';
import 'widgets/filter_sheet.dart';

class RealtimeScreen extends ConsumerStatefulWidget {
  const RealtimeScreen({super.key});

  @override
  ConsumerState<RealtimeScreen> createState() => _RealtimeScreenState();
}

class _RealtimeScreenState extends ConsumerState<RealtimeScreen>
    with PollingMixin {
  final _refresh = RefreshController();
  bool _paused = false;

  @override
  Duration get pollInterval => ApiConstants.realtimeRefreshInterval;

  @override
  void initState() {
    super.initState();
    startPolling();
  }

  @override
  bool shouldPoll() => shellBranchIsActive(context, 1);

  @override
  Future<void> onTick() async {
    if (_paused) return;
    await _refreshFeed();
  }

  Future<void> _refreshFeed() async {
    // `poll()` already catches everything it can raise, but reaching the
    // notifier is not covered: `onRetry` is a `VoidCallback`, so this future is
    // handed to a signature that discards it and any error here would have
    // nowhere to go but the zone.
    try {
      await ref.read(realtimeEventsProvider.notifier).poll();
      ref.invalidate(liveVisitorsProvider);
    } on Object catch (e, st) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'realtime',
          context: ErrorDescription('while refreshing the live event feed'),
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    await _refreshFeed();
    // The pull-to-refresh callback fires after the network round-trip; the
    // screen can be gone by then and completing on a disposed controller throws.
    if (!mounted) return;
    _refresh.refreshCompleted();
  }

  @override
  void dispose() {
    _refresh.dispose();
    super.dispose();
  }

  Future<void> _openFilters(List<OpenPanelEvent> events) async {
    final notifier = ref.read(realtimeEventsProvider.notifier);
    final countries = events
        .map((e) => e.geo.country)
        .whereType<String>()
        .toSet()
        .toList();
    final result = await showFilterSheet(
      context,
      current: ref.read(realtimeFiltersProvider),
      eventNames: notifier.knownNames.toList(),
      countries: countries,
    );
    if (result != null) ref.read(realtimeFiltersProvider.notifier).set(result);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(realtimeEventsProvider);
    final filters = ref.watch(realtimeFiltersProvider);
    final live = ref.watch(liveVisitorsProvider).value;
    final notifier = ref.read(realtimeEventsProvider.notifier);
    final all = async.value ?? const <OpenPanelEvent>[];
    final events = all.where(filters.matches).toList();
    final lastError = notifier.lastError;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const ProjectSelector(),
        actions: [
          Badge(
            isLabelVisible: !filters.isEmpty,
            label: Text('${filters.count}'),
            child: IconButton(
              tooltip: 'Filters',
              icon: const Icon(Icons.tune_rounded),
              onPressed: () => _openFilters(all),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _LiveHeader(
            paused: _paused,
            liveVisitors: live,
            shown: events.length,
            skipped: notifier.skipped,
            intervalSeconds: pollInterval.inSeconds,
            staleSince: notifier.lastUpdated,
            onToggle: () {
              final paused = !_paused;
              setState(() => _paused = paused);
              // Without this the feed stays frozen on whatever was on screen
              // when it was paused, and the gap looks like a quiet site.
              // Kept out of setState: starting network work inside a state
              // mutation is how re-entrant builds get scheduled.
              if (!paused) unawaited(_refreshFeed());
            },
          ),
          // A poll that fails after a successful one left the "Live" dot
          // pulsing over data that never changed. Say so instead.
          if (lastError != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: ErrorView(
                error: lastError,
                compact: true,
                onRetry: _refreshFeed,
              ),
            ),
          if (!filters.isEmpty)
            _ActiveFilters(
              filters: filters,
              onClear: () => ref.read(realtimeFiltersProvider.notifier).clear(),
            ),
          const Divider(height: 1),
          Expanded(
            child: async.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              loading: () => const SingleChildScrollView(child: ListSkeleton()),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(realtimeEventsProvider),
              ),
              data: (_) => SmartRefresher(
                controller: _refresh,
                onRefresh: _onRefresh,
                header: const MaterialClassicHeader(color: AppColors.accent),
                child: events.isEmpty
                    ? ListView(
                        children: [
                          const SizedBox(height: 60),
                          EmptyState(
                            illustration: EmptyIllustration.radar,
                            title: filters.isEmpty
                                ? 'Waiting for events'
                                : 'No events match',
                            message: filters.isEmpty
                                ? 'Nothing in the last 24 hours yet. Visit your site '
                                      'and it shows up here within 10 seconds.'
                                : 'Filters run against the events already loaded '
                                      'here, not your whole history. Try removing one.',
                          ),
                        ],
                      )
                    : ListView.separated(
                        itemCount: events.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1, indent: 64),
                        itemBuilder: (context, i) {
                          final e = events[i];
                          return EventTile(
                            event: e,
                            fresh: notifier.freshIds.contains(e.id),
                            onTap: () => showEventDetailSheet(context, e),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveHeader extends StatelessWidget {
  const _LiveHeader({
    required this.paused,
    required this.liveVisitors,
    required this.shown,
    required this.skipped,
    required this.intervalSeconds,
    required this.staleSince,
    required this.onToggle,
  });

  final bool paused;
  final int? liveVisitors;
  final int shown;

  /// Rows dropped because their payload was unusable.
  final int skipped;

  /// The poll cadence, so the label can't drift from `ApiConstants`.
  final int intervalSeconds;

  /// When the feed last changed. Null until the first successful load.
  final DateTime? staleSince;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final since = staleSince;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 10),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onToggle,
            child: Semantics(
              // The dot and the colour carry "live" visually; a screen reader
              // got only the word. The label states what tapping does.
              button: true,
              excludeSemantics: true,
              label: paused
                  ? 'Auto-refresh paused, tap to resume'
                  : 'Refreshing every $intervalSeconds seconds, tap to pause',
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: (paused ? AppColors.textMuted : AppColors.live)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (paused ? AppColors.textMuted : AppColors.live)
                        .withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    paused
                        ? const Icon(
                            Icons.pause_rounded,
                            size: 12,
                            color: AppColors.textMuted,
                          )
                        : const _PulsingDot(),
                    const SizedBox(width: 6),
                    Text(
                      paused ? 'Paused' : 'Live',
                      style: t.labelMedium?.copyWith(
                        color: paused ? AppColors.textMuted : AppColors.live,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (liveVisitors != null)
            Text(
              '$liveVisitors online now',
              style: t.labelMedium?.copyWith(color: AppColors.textPrimary),
            ),
          const Spacer(),
          Flexible(
            child: Text(
              [
                '$shown events',
                if (skipped > 0) '$skipped unreadable',
                if (paused)
                  since == null
                      ? 'paused'
                      : 'paused · updated ${Fmt.duration(DateTime.now().difference(since).inSeconds)} ago'
                else
                  '${intervalSeconds}s',
              ].join(' · '),
              style: t.labelSmall?.copyWith(color: AppColors.textMuted),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Stop the ticker instead of merely hiding it: an invisible repeating
    // animation still schedules a frame every frame.
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.stop();
      _c.value = 1.0;
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Decorative: the "Live" pill already states the state in text.
    return ExcludeSemantics(child: _build());
  }

  Widget _build() {
    final dot = Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.live,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColors.live, blurRadius: 6)],
      ),
    );
    if (MediaQuery.disableAnimationsOf(context)) return dot;
    return FadeTransition(
      opacity: Tween(begin: 0.35, end: 1.0).animate(_c),
      child: dot,
    );
  }
}

class _ActiveFilters extends StatelessWidget {
  const _ActiveFilters({required this.filters, required this.onClear});

  final EventFilters filters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final labels = [
      if (filters.eventName != null) 'Event: ${filters.eventName}',
      if (filters.country != null) 'Country: ${filters.country}',
      if (filters.device != null) 'Device: ${filters.device}',
    ];
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        children: [
          for (final l in labels)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(label: Text(l), visualDensity: VisualDensity.compact),
            ),
          ActionChip(
            avatar: const Icon(Icons.close_rounded, size: 16),
            label: const Text('Clear'),
            visualDensity: VisualDensity.compact,
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
