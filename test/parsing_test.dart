import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/core/network/api_exception.dart';
import 'package:openpanel_go/core/network/dio_client.dart';
import 'package:openpanel_go/core/network/export_charts.dart';
import 'package:openpanel_go/core/utils/formatters.dart';
import 'package:openpanel_go/features/realtime/data/event_models.dart';

void main() {
  test('parses /export/charts series', () {
    final body = {
      'series': [
        {
          'names': ['screen_view'],
          'data': [
            {
              'date': '2026-10-07T00:00:00.000Z',
              'count': 12,
              'previous': {'value': 9, 'diff': 33.3},
            },
            {'date': '2026-10-08 00:00:00', 'count': 4},
          ],
        },
      ],
    };
    final s = parseExportCharts(body);
    expect(s.single.points.length, 2);
    expect(s.single.points.first.count, 12);
    expect(s.single.points.first.previous, 9);
    expect(s.single.total, 16);
    expect(s.single.label, isNull);
  });

  test(
    'breakdown series expose their value as the label and sum the buckets',
    () {
      // This is the shape /export/charts actually returns. Summing a
      // `metrics.sum` field that isn't here made every fallback breakdown
      // render as an empty list.
      final body = {
        'series': [
          {
            'names': ['session_start', 'google.com'],
            'data': [
              {'date': '2026-10-07', 'count': 7},
              {'date': '2026-10-08', 'count': 3},
            ],
          },
          {
            'names': ['session_start', 'direct'],
            'data': [
              {'date': '2026-10-08', 'count': 5},
            ],
          },
        ],
      };
      final series = parseExportCharts(body);
      expect(series.map((s) => s.label), ['google.com', 'direct']);
      expect(series.first.total, 10);
      expect(series.last.total, 5);
    },
  );

  test('zone-less chart buckets are not shifted to UTC', () {
    // A bucket labelled 2026-10-08T00:00:00 is midnight in the *project's*
    // timezone. Re-reading it as UTC would slide the x-axis by the device
    // offset and can move a point across a day boundary.
    final parsed = parseApiDate('2026-10-08 00:00:00', assumeUtc: false)!;
    expect(parsed.isUtc, isFalse);
    expect(parsed.hour, 0);
    expect(parsed.day, 8);
  });

  test('event timestamps without a zone are read as UTC', () {
    final parsed = parseApiDate('2026-10-08T13:00:00.000')!;
    expect(parsed.isUtc, isTrue);
    expect(parseApiDate('2026-10-08 13:00:00')!.toUtc(), parsed);
    expect(parseApiDate(1759900800)?.isUtc, isTrue);
    expect(parseApiDate(null), isNull);
    expect(parseApiDate('not a date'), isNull);
  });

  test('parses a flat /export/events item', () {
    final e = OpenPanelEvent.fromApi({
      'id': 'e1',
      'name': 'screen_view',
      'createdAt': '2026-10-08T06:00:00.000Z',
      'path': '/pricing',
      'country': 'PK',
      'city': 'Lahore',
      'device': 'mobile',
      'os': 'iOS',
      'browser': 'Safari',
      'profileId': 'p1',
      'deviceId': 'd1',
      'properties': {'__title': 'Pricing'},
    });
    expect(e.path, '/pricing');
    expect(e.geo.country, 'PK');
    expect(e.device.isMobile, isTrue);
    // OpenPanel assigns a profileId to anonymous visitors too, and it always
    // differs from deviceId — so this visitor is still anonymous.
    expect(e.isIdentified, isFalse);
  });

  test('an event with a real identity is identified', () {
    final emailed = OpenPanelEvent.fromApi({
      'name': 'checkout',
      'createdAt': '2026-10-08T06:00:00.000Z',
      'profile': {'id': 'p1', 'email': 'me@example.com'},
    });
    expect(emailed.isIdentified, isTrue);
    expect(emailed.profile?.displayName, 'me@example.com');

    // Some servers only carry an external id and no isExternal flag.
    final external = OpenPanelEvent.fromApi({
      'name': 'checkout',
      'createdAt': '2026-10-08T06:00:00.000Z',
      'profile': {'id': 'p2', 'externalId': 'u-42'},
    });
    expect(external.isIdentified, isTrue);
  });

  test('rows without a usable timestamp are dropped, not dated "now"', () {
    // The feed is ordered newest-first by timestamp. Substituting now would
    // pin a broken row to the top of the list forever.
    final broken = {'id': 'e2', 'name': 'screen_view', 'createdAt': 'garbage'};
    expect(() => OpenPanelEvent.fromApi(broken), throwsFormatException);
    expect(OpenPanelEvent.tryFromApi(broken), isNull);
  });

  test('synthesised ids stay unique across the same millisecond', () {
    final j = {'name': 'screen_view', 'createdAt': '2026-10-08T06:00:00.000Z'};
    final a = OpenPanelEvent.fromApi(j, ordinal: 0);
    final b = OpenPanelEvent.fromApi(j, ordinal: 1);
    expect(a.id, isNot(b.id));
  });

  test('401 maps to the WRITE-client hint', () {
    final err = ApiException.fromDio(
      DioException(
        requestOptions: RequestOptions(path: '/export/events'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/export/events'),
          statusCode: 401,
          data: {'error': 'Unauthorized', 'message': 'Invalid client'},
        ),
      ),
    );
    expect(err.kind, ApiErrorKind.unauthorized);
    expect(err.message, contains('WRITE client'));
  });

  test('a cancelled request is silent, missing credentials are not', () {
    final cancelled = ApiException.fromDio(
      DioException(
        requestOptions: RequestOptions(path: '/export/events'),
        type: DioExceptionType.cancel,
      ),
    );
    expect(cancelled.kind, ApiErrorKind.cancelled);
    expect(cancelled.isSilent, isTrue);
    expect(cancelled.needsSetup, isFalse);

    late ApiException caught;
    try {
      throwNoCredentials();
    } on ApiException catch (e) {
      caught = e;
    }
    expect(caught.kind, ApiErrorKind.noCredentials);
    expect(caught.isSilent, isFalse);
    expect(caught.needsSetup, isTrue);
  });

  test('credentials never print the secret', () {
    const c = ApiCredentials(
      baseUrl: 'https://api.openpanel.dev',
      clientId: 'id',
      clientSecret: 'shh',
    );
    expect(c.toString(), isNot(contains('shh')));
    expect(normalizeBaseUrl('api.example.com/'), 'https://api.example.com');
  });

  test('the clipboard payload carries no direct identifiers', () {
    final e = OpenPanelEvent.fromApi({
      'id': 'e1',
      'name': 'page_view',
      'createdAt': '2026-10-01T10:00:00.000Z',
      'profile': {
        'id': 'p1',
        'firstName': 'Ada',
        'lastName': 'Lovelace',
        'email': 'ada@example.com',
        'avatar': 'https://cdn.example/a.png',
        'properties': {'stripe_id': 'cus_1'},
      },
      'country': 'FR',
      'latitude': 48.8584,
      'longitude': 2.2945,
      'sessionId': 's1',
      'properties': {'url': '/pricing', 'user_email': 'ada@example.com'},
    });

    final j = e.toShareableJson();
    final profile = j['profile'] as Map;
    expect(profile['email'], redactedValue);
    expect(profile['firstName'], redactedValue);
    expect(profile['lastName'], redactedValue);
    expect(profile.containsKey('avatar'), isFalse);
    expect(profile.containsKey('properties'), isFalse);

    final geo = j['geo'] as Map;
    expect(geo.containsKey('latitude'), isFalse);
    expect(geo.containsKey('longitude'), isFalse);
    expect(geo['country'], 'FR');

    final props = j['properties'] as Map;
    expect(props['url'], '/pricing');
    expect(props['user_email'], redactedValue);

    // Pseudonymous ids stay — a copied event is useless to support without them.
    expect(j['id'], 'e1');
    expect(j['sessionId'], 's1');
  });
}
