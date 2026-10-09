import '../utils/formatters.dart';

/// Wire model for `GET /export/charts`.
///
/// This is the only place that knows that response's shape. Both the overview
/// time-series and the insights breakdown fallback read it, so they cannot
/// drift — an earlier copy in `insights_repository` summed a `metrics.sum`
/// field the API never sends, which rendered every fallback breakdown as an
/// empty list on self-hosted servers without `/insights`.
class ChartPoint {
  const ChartPoint({required this.date, required this.count, this.previous});

  /// Bucket label, expressed in the *project's* timezone rather than UTC.
  final DateTime date;
  final double count;

  /// The same bucket in the previous period, when `previous: true` was sent.
  final double? previous;
}

class ChartSeries {
  const ChartSeries({required this.names, required this.points});

  /// `names[0]` is the event/segment name; the rest are breakdown values.
  final List<String> names;
  final List<ChartPoint> points;

  /// Breakdown value for this series, or null for an unbroken time series.
  String? get label => names.length > 1 ? names.sublist(1).join(' · ') : null;

  double get total => points.fold(0.0, (sum, p) => sum + p.count);

  double get previousTotal =>
      points.fold(0.0, (sum, p) => sum + (p.previous ?? 0));
}

/// Parses `{ series: [ { names: [...], data: [ { date, count, previous? } ] } ] }`.
/// Unrecognisable payloads yield an empty list rather than throwing, so one
/// malformed response can't take down the whole screen.
List<ChartSeries> parseExportCharts(dynamic body) {
  if (body is! Map) return const [];
  final raw = body['series'];
  if (raw is! List) return const [];
  final out = <ChartSeries>[];
  for (final entry in raw) {
    if (entry is! Map) continue;
    final points = <ChartPoint>[];
    for (final d in (entry['data'] as List? ?? const [])) {
      if (d is! Map) continue;
      final date = parseApiDate(d['date'], assumeUtc: false);
      if (date == null) continue;
      points.add(
        ChartPoint(
          date: date,
          count: _num(d['count']) ?? _num(d['value']) ?? 0,
          previous: _num(d['previous']) ?? _numIn(d['previous']),
        ),
      );
    }
    out.add(
      ChartSeries(
        names: _names(entry['names'] ?? entry['name']),
        points: points,
      ),
    );
  }
  return out;
}

List<String> _names(Object? raw) {
  if (raw is List) return raw.map((e) => e.toString()).toList();
  if (raw == null) return const [];
  return [raw.toString()];
}

/// num passes through; a numeric string is what proxies and some self-hosted
/// builds send for `count` — the same coercion `asDouble` exists for, and the
/// reader every other API numeric uses. Under num-only parsing a "12" fell
/// through to 0, which the insights breakdown fallback then *drops*
/// (`total <= 0`), silently hiding a top page/country.
///
/// Genuine absence stays null so the `?? value` fallback and the "server didn't
/// send a previous period" distinction (vs a real 0) keep working.
double? _num(Object? raw) => switch (raw) {
  final num n => n.toDouble(),
  final String s => double.tryParse(s),
  _ => null,
};

double? _numIn(Object? raw) => raw is Map ? _num(raw['value']) : null;
