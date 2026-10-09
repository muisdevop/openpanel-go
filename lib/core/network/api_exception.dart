import 'package:dio/dio.dart';

enum ApiErrorKind {
  unauthorized,
  forbidden,
  notFound,
  badRequest,
  rateLimited,
  server,
  network,
  timeout,

  /// No client secret on this device for the selected project.
  noCredentials,

  /// No project selected at all — the router should have redirected.
  noProject,

  /// The request was aborted locally (project switch, disposal, superseded poll).
  cancelled,
  unknown,
}

/// A typed, user-presentable API failure. Never carries credentials.
class ApiException implements Exception {
  const ApiException(this.kind, this.message, {this.statusCode, this.detail});

  final ApiErrorKind kind;
  final String message;
  final int? statusCode;

  /// Raw server message, if any (already free of secrets).
  final String? detail;

  bool get isAuth =>
      kind == ApiErrorKind.unauthorized || kind == ApiErrorKind.forbidden;

  /// Not a failure the user should ever see as an error screen.
  bool get isSilent => kind == ApiErrorKind.cancelled;

  /// The fix is on the device, not on the server: re-enter credentials or add
  /// a project. A retry button can't help these, so the UI must offer the
  /// setup action instead.
  bool get needsSetup =>
      kind == ApiErrorKind.noCredentials || kind == ApiErrorKind.noProject;

  /// The named constructors below are the canonical ways to build these; the
  /// fields are public only so [from] can rebuild an already-typed error.
  const ApiException.noProject()
    : this(ApiErrorKind.noProject, noProjectMessage);

  const ApiException.missingCredentials()
    : this(ApiErrorKind.noCredentials, noCredentialsMessage);

  /// Aborted locally — a superseded poll, or a client closed under a request.
  const ApiException.cancelled()
    : this(ApiErrorKind.cancelled, 'Request cancelled.');

  String get title => switch (kind) {
    ApiErrorKind.unauthorized => 'Not authorized',
    ApiErrorKind.forbidden => 'No access to this project',
    ApiErrorKind.notFound => 'Project not found',
    ApiErrorKind.badRequest => 'Bad request',
    ApiErrorKind.rateLimited => 'Slow down',
    ApiErrorKind.server => 'OpenPanel had a problem',
    ApiErrorKind.network => 'You\'re offline',
    ApiErrorKind.timeout => 'Request timed out',
    ApiErrorKind.noCredentials => 'Credentials missing',
    ApiErrorKind.noProject => 'No project selected',
    ApiErrorKind.cancelled => 'Request cancelled',
    ApiErrorKind.unknown => 'Something went wrong',
  };

  static const noCredentialsMessage =
      'This project\'s client secret isn\'t on this device anymore '
      '(e.g. after a restore). Re-enter it to continue.';

  static const noProjectMessage =
      'No project is selected. Add one to see analytics.';

  static const writeClientHint =
      'You are using a WRITE client. Create a READ client in the dashboard: '
      'Project Settings → Clients → Create client → Mode: Read.';

  /// The server rejected this project's credentials (401/403).
  ///
  /// Built here rather than only from a live [DioException] because the shell
  /// intercepts the rejection as soon as any one request gets a 401 — the
  /// message is the same, and every endpoint would otherwise keep saying it.
  factory ApiException.credentialsRejected(int statusCode) => statusCode == 403
      ? forbidden(statusCode, null)
      : unauthorized(statusCode, null);

  static ApiException unauthorized(int? statusCode, String? detail) =>
      ApiException(
        ApiErrorKind.unauthorized,
        writeClientHint,
        statusCode: statusCode,
        detail: detail,
      );

  static ApiException forbidden(int? statusCode, String? detail) =>
      ApiException(
        ApiErrorKind.forbidden,
        'This client can\'t read that project. A READ client only works for '
        'the project it was created in. Check the Project ID.',
        statusCode: statusCode,
        detail: detail,
      );

  factory ApiException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    final detail = _serverMessage(e.response?.data);
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          ApiErrorKind.timeout,
          'The server took too long to answer. Check your connection and retry.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          ApiErrorKind.network,
          'Couldn\'t reach the server. Check your connection or the Base URL.',
        );
      case DioExceptionType.badCertificate:
        return const ApiException(
          ApiErrorKind.network,
          'The server\'s TLS certificate isn\'t trusted.',
        );
      case DioExceptionType.cancel:
        return const ApiException(ApiErrorKind.cancelled, 'Request cancelled.');
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        break;
    }
    if (status == null) {
      return ApiException(
        ApiErrorKind.network,
        'Couldn\'t reach the server. Check your connection or the Base URL.',
        detail: detail,
      );
    }
    return switch (status) {
      401 => unauthorized(status, detail),
      403 => forbidden(status, detail),
      404 => ApiException(
        ApiErrorKind.notFound,
        'Wrong Project ID, or the Base URL doesn\'t point at an OpenPanel API.',
        statusCode: status,
        detail: detail,
      ),
      400 || 422 => ApiException(
        ApiErrorKind.badRequest,
        detail ?? 'The server rejected the request.',
        statusCode: status,
        detail: detail,
      ),
      429 => ApiException(
        ApiErrorKind.rateLimited,
        'Too many requests (limit is 100 per 10s). Retrying shortly.',
        statusCode: status,
        detail: detail,
      ),
      >= 500 => ApiException(
        ApiErrorKind.server,
        'OpenPanel returned $status. Try again in a moment.',
        statusCode: status,
        detail: detail,
      ),
      _ => ApiException(
        ApiErrorKind.unknown,
        detail ?? 'Unexpected response ($status).',
        statusCode: status,
        detail: detail,
      ),
    };
  }

  static ApiException from(Object error) {
    if (error is ApiException) return error;
    if (error is DioException) {
      final inner = error.error;
      if (inner is ApiException) return inner;
      return ApiException.fromDio(error);
    }
    // A TypeError from a parser or a storage failure is developer text: the
    // user can't act on it, and repeating it on screen invites raw server
    // bodies into the UI. Keep it in `detail` (expandable) and say the useful
    // part in `message`.
    return ApiException(
      ApiErrorKind.unknown,
      'The app could not read the server response.',
      detail: error.toString(),
    );
  }

  static String? _serverMessage(Object? data) {
    if (data is Map) {
      final m = data['message'] ?? data['error'];
      if (m is String && m.trim().isNotEmpty) return m.trim();
    }
    // A proxy or older gateway answers 5xx with an HTML page; rendering that
    // verbatim is a wall of markup, not a message.
    if (data is String &&
        data.trim().isNotEmpty &&
        data.length < 300 &&
        !data.contains('<')) {
      return data.trim();
    }
    return null;
  }

  @override
  String toString() => 'ApiException($kind, $statusCode): $message';
}

/// Shared guard for "this project exists but has no secret on this device".
///
/// Every repository used to return an empty list / zeroed metrics here, which
/// rendered as "no traffic" and told the user their site was dead when the app
/// had never made a request.
Never throwNoCredentials() => throw const ApiException.missingCredentials();

/// Shared guard for "no project is selected". The router is supposed to make
/// this unreachable; if it isn't, an explicit error beats a silent empty screen.
Never throwNoProject() => throw const ApiException.noProject();
