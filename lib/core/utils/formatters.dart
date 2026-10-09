import 'package:intl/intl.dart';

abstract final class Fmt {
  static final _compact = NumberFormat.compact();
  static final _decimal = NumberFormat.decimalPattern();
  static final _decimalFrac = NumberFormat('#,##0.##');

  static String compact(num? v) {
    if (v == null) return '–';
    if (v.abs() < 10000) {
      return v == v.roundToDouble()
          ? _decimal.format(v.round())
          : _decimalFrac.format(v);
    }
    return _compact.format(v);
  }

  static String number(num? v) => v == null ? '–' : _decimal.format(v);

  static String percent(num? v, {int digits = 1}) =>
      v == null ? '–' : '${v.toStringAsFixed(digits)}%';

  /// Seconds → "2m 14s".
  static String duration(num? seconds) {
    if (seconds == null) return '–';
    final s = seconds.round();
    if (s < 60) return '${s}s';
    final m = s ~/ 60;
    if (m < 60) return '${m}m ${s % 60}s';
    return '${m ~/ 60}h ${m % 60}m';
  }

  /// Percent change from [previous] to [current]; null when undefined.
  static double? change(num? current, num? previous) {
    if (current == null || previous == null || previous == 0) return null;
    return (current - previous) / previous * 100;
  }
}

/// Parses dates the API emits ("2026-10-08 13:00:00", ISO with/without Z).
///
/// [assumeUtc] decides what a *zone-less* string means. Event timestamps come
/// from the server in UTC, so they must be read as UTC — `DateTime.tryParse`
/// would otherwise interpret them in the device's timezone and shift every
/// event by the local offset. Chart bucket labels are already expressed in the
/// project's timezone and must be left untouched, so those pass `false`.
DateTime? parseApiDate(Object? raw, {bool assumeUtc = true}) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  if (raw is num) {
    final v = raw.toInt();
    // Tolerate epoch seconds as well as epoch milliseconds.
    final ms = v.abs() < 100000000000 ? v * 1000 : v;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }
  final s = raw.toString().trim();
  if (s.isEmpty) return null;
  final iso = s.contains('T') ? s : s.replaceFirst(' ', 'T');
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return null;
  if (!assumeUtc || _hasZone(iso)) return parsed;
  return DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
    parsed.microsecond,
  );
}

final _zoneSuffix = RegExp(r'(?:Z|[+-]\d{2}:?\d{2})$', caseSensitive: false);

bool _hasZone(String iso) => _zoneSuffix.hasMatch(iso);

/// The host of [url], falling back to the raw string.
///
/// `Uri.parse(url).host` throws on anything malformed, and a project row saved
/// by an older build was enough to crash the switcher and Settings outright.
String urlHost(String url) {
  final host = Uri.tryParse(url)?.host;
  return host == null || host.isEmpty ? url : host;
}
