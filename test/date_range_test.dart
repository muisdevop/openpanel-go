import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/core/models/date_range.dart';

void main() {
  test('presets map to API range values', () {
    expect(const SelectedDateRange.preset(DateRangePreset.today).toQuery(), {
      'range': 'today',
    });
    expect(
      const SelectedDateRange.preset(DateRangePreset.last7Days).toQuery(),
      {'range': '7d'},
    );
  });

  test('lastMonth is the previous complete calendar month, sent as bounds', () {
    const r = SelectedDateRange.preset(DateRangePreset.lastMonth);
    final (s, e) = r.bounds;
    // A whole calendar month: the 1st through that month's last day. These
    // checks are deliberately now-independent — they characterise the window's
    // shape, not which month it happens to be.
    expect(s.day, 1);
    expect(s.year, e.year);
    expect(s.month, e.month);
    expect(DateTime(e.year, e.month, e.day + 1).day, 1); // e is the last day
    expect(e.isBefore(DateTime.now()), isTrue);
    expect(r.dayCount, SelectedDateRange.daysBetween(s, e) + 1);
    expect(r.interval, 'day');
    // No OpenPanel `range=` token for a calendar month, so the query carries
    // explicit dates like custom, not `{'range': 'custom'}` alone.
    expect(r.needsExplicitBounds, isTrue);
    expect(r.toQuery()['range'], 'custom');
    expect(r.toQuery().containsKey('startDate'), isTrue);
    expect(r.toQuery().containsKey('endDate'), isTrue);
    expect(r.label, 'Last month');
    // cacheIdentity is stamped by the resolved month start, so a boundary
    // rollover cannot serve the previous month's data from a fresh cache key.
    expect(r.cacheIdentity, contains('lastMonth'));
    expect(r.cacheIdentity, contains(SelectedDateRange.ymd(s)));
  });

  test('previous window has the same length and ends the day before', () {
    final r = SelectedDateRange(
      DateRangePreset.custom,
      customStart: DateTime(2026, 9, 10),
      customEnd: DateTime(2026, 9, 16),
    );
    expect(r.toQuery(), {
      'range': 'custom',
      'startDate': '2026-09-10',
      'endDate': '2026-09-16',
    });
    expect(r.toPreviousQuery(), {
      'range': 'custom',
      'startDate': '2026-09-03',
      'endDate': '2026-09-09',
    });
  });

  test('interval is hourly for single days', () {
    expect(
      const SelectedDateRange.preset(DateRangePreset.today).interval,
      'hour',
    );
    expect(
      const SelectedDateRange.preset(DateRangePreset.last30Days).interval,
      'day',
    );
  });

  test('previous window shifts by calendar days, not elapsed ones', () {
    // 2026-03-08 is a US DST spring-forward day: it is 23 hours long, so a
    // shift computed from Duration.inDays truncates to the wrong date on a
    // device in that zone. The window is built from year/month/day components
    // instead, which is why these expectations hold in any local zone.
    final r = SelectedDateRange(
      DateRangePreset.custom,
      customStart: DateTime(2026, 3, 9),
      customEnd: DateTime(2026, 3, 15),
    );
    final (ps, pe) = r.previousBounds;
    expect([ps.year, ps.month, ps.day], [2026, 3, 2]);
    expect([pe.year, pe.month, pe.day], [2026, 3, 8]);
    expect(SelectedDateRange.daysBetween(ps, pe) + 1, r.dayCount);
  });

  test('a month-boundary window keeps its length in the previous period', () {
    final r = SelectedDateRange(
      DateRangePreset.custom,
      customStart: DateTime(2026, 3, 1),
      customEnd: DateTime(2026, 3, 31),
    );
    final (ps, pe) = r.previousBounds;
    expect([ps.year, ps.month, ps.day], [2026, 1, 29]);
    expect([pe.year, pe.month, pe.day], [2026, 2, 28]);
    expect(r.dayCount, 31);
  });
}
