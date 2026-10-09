import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openpanel_go/core/network/api_exception.dart';
import 'package:openpanel_go/core/network/dio_client.dart';

/// Answers every request with one fixed status, and counts how many arrived.
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.status);

  final int status;
  int requests = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests++;
    return ResponseBody.fromString(
      '{"message":"invalid credentials"}',
      status,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

OpenPanelApi _api(_StubAdapter adapter, {required List<int> rejected}) {
  final api = OpenPanelApi(
    const ApiCredentials(
      baseUrl: 'https://bench.openpanel.com',
      clientId: 'cid',
      clientSecret: 'secret',
    ),
    onAuthRejected: rejected.add,
  )..dio.httpClientAdapter = adapter;
  return api;
}

void main() {
  test('a 401 reports the rejection once and is not retried', () async {
    final rejected = <int>[];
    final adapter = _StubAdapter(401);
    final api = _api(adapter, rejected: rejected);
    addTearDown(api.close);

    await expectLater(
      api.get('/insights/p/metrics'),
      throwsA(isA<ApiException>()),
    );
    expect(rejected, [401]);
    expect(adapter.requests, 1);
  });

  test('a 403 reports the rejection too', () async {
    final rejected = <int>[];
    final api = _api(_StubAdapter(403), rejected: rejected);
    addTearDown(api.close);

    await expectLater(
      api.get('/insights/p/metrics'),
      throwsA(isA<ApiException>()),
    );
    expect(rejected, [403]);
  });

  test(
    'a 500 is retried and does not look like a rejected credential',
    () async {
      final rejected = <int>[];
      final adapter = _StubAdapter(500);
      final api = _api(adapter, rejected: rejected);
      addTearDown(api.close);

      await expectLater(
        api.get('/insights/p/metrics'),
        throwsA(isA<ApiException>()),
      );
      expect(rejected, isEmpty);
      expect(adapter.requests, greaterThan(1));
    },
  );

  test(
    'credentialsRejected carries the same user-facing text as the live error',
    () {
      final asIfRejected = ApiException.credentialsRejected(401);
      expect(asIfRejected.isAuth, isTrue);
      expect(asIfRejected.message, ApiException.writeClientHint);

      final live403 = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/insights/p/metrics'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/insights/p/metrics'),
            statusCode: 403,
          ),
        ),
      );
      final rejected403 = ApiException.credentialsRejected(403);
      expect(rejected403.kind, ApiErrorKind.forbidden);
      expect(rejected403.message, live403.message);
    },
  );
}
