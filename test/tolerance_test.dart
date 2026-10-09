import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/core/models/date_range.dart';
import 'package:openpanel_go/core/network/api_exception.dart';
import 'package:openpanel_go/core/utils/coerce.dart';
import 'package:openpanel_go/features/overview/data/overview_models.dart';
import 'package:openpanel_go/features/realtime/data/event_models.dart';

void main() {
  group('tolerant coercion', () {
    test('reads numbers out of strings instead of throwing', () {
      expect(asDouble('42.5'), 42.5);
      expect(asInt('7'), 7);
      expect(asDouble(3), 3.0);
      expect(asString(9), '9');
    });

    test('an unusable value costs the field, not the screen', () {
      expect(asDouble(null), 0);
      expect(asDouble(const {}), 0);
      expect(asInt('n/a'), 0);
      expect(asString(null), isNull);
    });

    test('metrics survive a server that serialises them as strings', () {
      final m = MetricsSnapshot.fromApi({
        'unique_visitors': '1200',
        'total_sessions': 1500.0,
        'bounce_rate': '33.3',
      });
      expect(m.uniqueVisitors, 1200);
      expect(m.totalSessions, 1500);
      expect(m.bounceRate, 33.3);
      // Absent keys stay zero, which the UI renders as a real zero.
      expect(m.viewsPerSession, 0);
    });

    test('event coordinates and durations accept string forms', () {
      final e = OpenPanelEvent.fromApi({
        'id': 'e1',
        'createdAt': '2026-10-08T10:00:00.000Z',
        'name': 'page_view',
        'latitude': '48.8584',
        'longitude': '2.2945',
        'duration': '12',
        'profile': {'id': 42, 'email': 7},
      });
      expect(e.geo.latitude, 48.8584);
      expect(e.duration, 12);
      expect(e.profile!.id, '42');
      expect(e.profile!.email, '7');
    });

    test('tryFromApi skips a row whose shape is wrong, never the feed', () {
      final good = OpenPanelEvent.tryFromApi({
        'id': 'e1',
        'createdAt': '2026-10-08T10:00:00.000Z',
        'name': 'page_view',
      });
      final bad = OpenPanelEvent.tryFromApi({
        'id': 'e2',
        'createdAt': 'yesterday',
        'name': 'page_view',
      });
      expect(good, isNotNull);
      expect(bad, isNull);
    });
  });

  group('ApiException message hygiene', () {
    test('raw exception text goes to detail, not the headline', () {
      final e = ApiException.from(TypeError());
      expect(e.kind, ApiErrorKind.unknown);
      expect(e.message, isNot(contains('TypeError')));
      expect(e.detail, contains('TypeError'));
    });

    test('an HTML gateway page is not shown as a message', () {
      final options = RequestOptions(path: '/insights/p/metrics');
      final e = ApiException.fromDio(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 502,
            data: '<html><body><h1>502 Bad Gateway</h1></body></html>',
          ),
        ),
      );
      expect(e.kind, ApiErrorKind.server);
      expect(e.detail, isNull);
      expect(e.message, isNot(contains('<html')));
    });
  });

  group('cache identity', () {
    test('day-granularity presets are stamped with the local date', () {
      final today = SelectedDateRange.preset(DateRangePreset.today)
          .cacheIdentity;
      expect(today, contains(DateRangePreset.today.name));
      expect(today, contains(SelectedDateRange.ymd(DateTime.now())));
    });

    test('multi-day presets stay date-free so the TTL governs them', () {
      final r = SelectedDateRange.preset(DateRangePreset.last7Days);
      expect(
        r.cacheIdentity,
        isNot(contains(SelectedDateRange.ymd(DateTime.now()))),
      );
      expect(r.cacheIdentity, contains('last7Days'));
    });

    test('custom ranges key on their bounds', () {
      final r = SelectedDateRange(
        DateRangePreset.custom,
        customStart: DateTime(2026, 3, 1),
        customEnd: DateTime(2026, 3, 8),
      );
      expect(r.cacheIdentity, contains('2026-03-01T00:00:00.000'));
    });
  });
}
