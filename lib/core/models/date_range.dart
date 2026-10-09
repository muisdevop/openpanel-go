import 'dart:convert';

import 'package:intl/intl.dart';

enum DateRangePreset {
  today('Today', 'today'),
  yesterday('Yesterday', 'yesterday'),
  last7Days('Last 7 days', '7d'),
  last30Days('Last 30 days', '30d'),
  custom('Custom', 'custom');

  const DateRangePreset(this.label, this.apiRange);
  final String label;

  /// Value the API understands for `range=`.
  final String apiRange;
}

/// The date range the user picked. Presets are sent to the API as `range=`
/// so OpenPanel resolves them in the project's timezone, exactly like the
/// web dashboard does. Custom ranges are sent as `yyyy-MM-dd` bounds.
class SelectedDateRange {
  const SelectedDateRange(this.preset, {this.customStart, this.customEnd});

  const SelectedDateRange.preset(this.preset)
    : customStart = null,
      customEnd = null;

  final DateRangePreset preset;
  final DateTime? customStart;
  final DateTime? customEnd;

  static final _ymd = DateFormat('yyyy-MM-dd');
  static String ymd(DateTime d) => _ymd.format(d);

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// Inclusive local-calendar bounds of the current window.
  (DateTime start, DateTime end) get bounds {
    final t = _today;
    return switch (preset) {
      DateRangePreset.today => (t, t),
      DateRangePreset.yesterday => (
        t.subtract(const Duration(days: 1)),
        t.subtract(const Duration(days: 1)),
      ),
      DateRangePreset.last7Days => (t.subtract(const Duration(days: 6)), t),
      DateRangePreset.last30Days => (t.subtract(const Duration(days: 29)), t),
      DateRangePreset.custom => (
        customStart ?? t,
        customEnd ?? customStart ?? t,
      ),
    };
  }

  /// Calendar-day difference, immune to DST. `Duration.inDays` truncates, so
  /// differencing local midnights across a spring-forward loses a whole day.
  static int daysBetween(DateTime a, DateTime b) => DateTime.utc(
    b.year,
    b.month,
    b.day,
  ).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

  /// The equally long window right before this one.
  (DateTime start, DateTime end) get previousBounds {
    final (s, e) = bounds;
    final days = daysBetween(s, e) + 1;
    final pe = DateTime(s.year, s.month, s.day - 1);
    final ps = DateTime(pe.year, pe.month, pe.day - (days - 1));
    return (ps, pe);
  }

  int get dayCount {
    final (s, e) = bounds;
    return daysBetween(s, e) + 1;
  }

  /// Hourly buckets for single-day windows, daily otherwise.
  String get interval => dayCount <= 1 ? 'hour' : 'day';

  /// Query params for the current window.
  Map<String, dynamic> toQuery() {
    if (preset != DateRangePreset.custom) {
      return {'range': preset.apiRange};
    }
    final (s, e) = bounds;
    return {'range': 'custom', 'startDate': ymd(s), 'endDate': ymd(e)};
  }

  /// Label for the window [previousBounds] covers.
  String get previousLabel {
    final (s, e) = previousBounds;
    final f = DateFormat.MMMd();
    return s == e ? f.format(s) : '${f.format(s)} – ${f.format(e)}';
  }

  /// Query params for the previous window (always explicit dates).
  Map<String, dynamic> toPreviousQuery() {
    final (s, e) = previousBounds;
    return {'range': 'custom', 'startDate': ymd(s), 'endDate': ymd(e)};
  }

  String get label {
    if (preset != DateRangePreset.custom) return preset.label;
    final (s, e) = bounds;
    final f = DateFormat.MMMd();
    return s == e ? f.format(s) : '${f.format(s)} – ${f.format(e)}';
  }

  Map<String, dynamic> toJson() => {
    'preset': preset.name,
    if (customStart != null) 'start': customStart!.toIso8601String(),
    if (customEnd != null) 'end': customEnd!.toIso8601String(),
  };

  /// Cache key fragment. [toJson] encodes no calendar date for presets, so a
  /// `metrics:<project>:{"preset":"today"}` entry written last night is still
  /// "today's traffic" inside the 24h TTL. Stamping day-granularity presets
  /// makes the stale entry unreachable rather than misleading.
  String get cacheIdentity => switch (preset) {
    DateRangePreset.today ||
    DateRangePreset.yesterday => '${preset.name}:${ymd(DateTime.now())}',
    _ => jsonEncode(toJson()),
  };

  factory SelectedDateRange.fromJson(Map<String, dynamic> json) {
    final preset = DateRangePreset.values.firstWhere(
      (p) => p.name == json['preset'],
      orElse: () => DateRangePreset.last7Days,
    );
    final start = DateTime.tryParse(json['start'] as String? ?? '');
    final end = DateTime.tryParse(json['end'] as String? ?? '');
    // A persisted custom range with a missing bound must not silently degrade
    // to "today"; fall back to the default preset instead.
    if (preset == DateRangePreset.custom && (start == null || end == null)) {
      return const SelectedDateRange.preset(DateRangePreset.last7Days);
    }
    return SelectedDateRange(preset, customStart: start, customEnd: end);
  }

  @override
  bool operator ==(Object other) =>
      other is SelectedDateRange &&
      other.preset == preset &&
      other.customStart == customStart &&
      other.customEnd == customEnd;

  @override
  int get hashCode => Object.hash(preset, customStart, customEnd);
}
