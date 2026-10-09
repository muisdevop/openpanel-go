/// Static values for the OpenPanel API.
///
/// Auth model (https://openpanel.dev/docs/api/authentication):
///   `openpanel-client-id: CLIENT_ID`
///   `openpanel-client-secret: CLIENT_SECRET`
/// The default client a project ships with is `write` only. The Export and
/// Insights APIs need a `read` (or `root`) client.
abstract final class ApiConstants {
  static const defaultBaseUrl = 'https://api.openpanel.dev';
  static const dashboardUrl = 'https://dashboard.openpanel.dev';
  static const docsAuthUrl = 'https://openpanel.dev/docs/api/authentication';
  static const docsExportUrl = 'https://openpanel.dev/docs/api/export';
  static const websiteUrl = 'https://openpanel.dev';
  static const repoUrl = 'https://github.com/muisdevop/openpanel-go';

  static const headerClientId = 'openpanel-client-id';
  static const headerClientSecret = 'openpanel-client-secret';

  // Export API
  static const exportEvents = '/export/events';
  static const exportCharts = '/export/charts';

  // Insights API (same read client). Session-based numbers, identical to the
  // ones dashboard.openpanel.dev renders on its overview.
  static String insightsMetrics(String projectId) =>
      '/insights/${Uri.encodeComponent(projectId)}/metrics';
  static String insightsLive(String projectId) =>
      '/insights/${Uri.encodeComponent(projectId)}/live';
  static String insightsPages(String projectId) =>
      '/insights/${Uri.encodeComponent(projectId)}/pages';
  static String insightsColumn(String projectId, String column) =>
      '/insights/${Uri.encodeComponent(projectId)}'
      '/${Uri.encodeComponent(column)}';

  /// Every column `/export/events?includes=` understands (they map 1:1 to
  /// the server's select keys).
  static const eventIncludes = <String>[
    'profile',
    'properties',
    'region',
    'longitude',
    'latitude',
    'device',
    'brand',
    'model',
    'osVersion',
    'browserVersion',
    'referrer',
    'referrerName',
    'referrerType',
    'origin',
    'sdkName',
    'sdkVersion',
  ];

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);

  static const overviewRefreshInterval = Duration(seconds: 60);
  static const realtimeRefreshInterval = Duration(seconds: 10);
}
