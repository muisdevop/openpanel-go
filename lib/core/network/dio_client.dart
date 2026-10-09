import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import 'api_exception.dart';

/// Credentials needed to talk to one OpenPanel project.
class ApiCredentials {
  const ApiCredentials({
    required this.baseUrl,
    required this.clientId,
    required this.clientSecret,
  });

  final String baseUrl;
  final String clientId;
  final String clientSecret;

  // Never let the secret leak through logs or error reports.
  @override
  String toString() => 'ApiCredentials(baseUrl: $baseUrl, clientId: $clientId)';
}

/// Normalises what a user pastes: trims, adds https://, drops trailing slashes.
String normalizeBaseUrl(String input) {
  var url = input.trim();
  if (url.isEmpty) return ApiConstants.defaultBaseUrl;
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'https://$url';
  }
  while (url.endsWith('/')) {
    url = url.substring(0, url.length - 1);
  }
  return url;
}

/// Adds the two OpenPanel auth headers to every request.
class OpenPanelAuthInterceptor extends Interceptor {
  OpenPanelAuthInterceptor(this._credentials);

  final ApiCredentials _credentials;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiConstants.headerClientId] = _credentials.clientId;
    options.headers[ApiConstants.headerClientSecret] =
        _credentials.clientSecret;
    handler.next(options);
  }
}

/// Maps every DioException to an [ApiException] carried in `error`.
class ErrorMappingInterceptor extends Interceptor {
  ErrorMappingInterceptor({this.onAuthRejected});

  /// Called once per rejected request (401/403) so the app can stop hammering a
  /// dead endpoint. Null for throwaway clients like the login screen's test.
  final void Function(int statusCode)? onAuthRejected;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    if (status == 401 || status == 403) {
      onAuthRejected?.call(status!);
    }
    handler.next(err.copyWith(error: ApiException.fromDio(err)));
  }
}

Dio createDio(
  ApiCredentials credentials, {
  void Function(int statusCode)? onAuthRejected,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: normalizeBaseUrl(credentials.baseUrl),
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      responseType: ResponseType.json,
      headers: {'accept': 'application/json'},
    ),
  );
  dio.interceptors.addAll([
    OpenPanelAuthInterceptor(credentials),
    ErrorMappingInterceptor(onAuthRejected: onAuthRejected),
    if (kDebugMode)
      PrettyDioLogger(
        // requestHeader stays OFF: it would print openpanel-client-secret.
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
        compact: true,
      ),
  ]);
  return dio;
}

/// Thin typed wrapper over Dio for the OpenPanel API.
class OpenPanelApi {
  OpenPanelApi(
    this.credentials, {
    void Function(int statusCode)? onAuthRejected,
  }) : dio = createDio(credentials, onAuthRejected: onAuthRejected);

  final ApiCredentials credentials;
  final Dio dio;

  /// Requests are queued instead of fired all at once. The API allows 100 per
  /// 10s, and building the Insights screen issues six while Overview polls four
  /// a minute — an unbounded fan-out against a slow server becomes a burst that
  /// earns a 429, which the retry interceptor then amplifies.
  static const _maxInFlight = 3;
  static const _maxRetries = 2;

  /// The rate-limit window is 10 s, so a 429 retried after 600 ms lands inside
  /// the *same* window and is guaranteed to be refused again. Rate-limited
  /// requests wait the window out (or whatever `Retry-After` asks for).
  static const _rateLimitWindow = Duration(seconds: 10);
  static const _backoffBase = Duration(milliseconds: 600);

  int _inFlight = 0;
  bool _closed = false;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    // Retries live here rather than in an interceptor that re-fetches on the
    // raw Dio: an interceptor retry escapes the queue, so three queued requests
    // plus their retries all hit the server at once. Looping above `_send`
    // releases the slot while waiting and re-acquires it like any other call.
    for (var attempt = 0; ; attempt++) {
      try {
        return await _send(path, query);
      } on DioException catch (e) {
        final delay = _retryDelay(e, attempt);
        if (delay == null) throw ApiException.from(e);
        await Future<void>.delayed(delay);
      }
    }
  }

  Future<dynamic> _send(String path, Map<String, dynamic>? query) async {
    await _acquire();
    try {
      final res = await dio.get<dynamic>(path, queryParameters: query);
      return res.data;
    } finally {
      _release();
    }
  }

  /// Null when this failure must reach the caller as an error.
  static Duration? _retryDelay(DioException e, int attempt) {
    if (attempt >= _maxRetries) return null;
    final status = e.response?.statusCode;
    final rateLimited = status == 429;
    final retryable =
        rateLimited ||
        (status != null && status >= 500) ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout;
    if (!retryable) return null;
    if (!rateLimited) return _backoffBase * (1 << attempt);
    final seconds = double.tryParse(
      e.response?.headers.value('retry-after')?.trim() ?? '',
    );
    if (seconds != null) {
      return Duration(milliseconds: (seconds * 1000).round());
    }
    return _rateLimitWindow;
  }

  Future<void> _acquire() async {
    if (_closed) throw const ApiException.cancelled();
    if (_inFlight < _maxInFlight) {
      _inFlight++;
      return;
    }
    final waiter = Completer<void>();
    _waiters.add(waiter);
    await waiter.future;
  }

  void _release() {
    if (_waiters.isNotEmpty) {
      _waiters.removeFirst().complete();
    } else {
      _inFlight--;
    }
  }

  /// Graceful: in-flight requests finish, queued ones are cancelled. The old
  /// `close(force: true)` aborted every outstanding request, so switching
  /// project turned into a cancel error on the screen the user just left.
  void close() {
    _closed = true;
    for (final w in _waiters) {
      w.completeError(const ApiException.cancelled());
    }
    _waiters.clear();
    dio.close();
  }
}
