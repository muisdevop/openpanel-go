import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/models/project_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/providers.dart';
import '../../../core/storage/secure_storage_service.dart';

part 'auth_repository.g.dart';

class ConnectionResult {
  const ConnectionResult({required this.totalEvents});
  final int? totalEvents;
}

class AuthRepository {
  AuthRepository(this._secure, this._projects);

  final SecureStorageService _secure;
  final Projects _projects;

  /// GET /export/events?projectId=…&limit=1 with the two auth headers.
  /// Throws [ApiException]: 401 → write client / bad creds, 403 → client
  /// belongs to another project, 404 → wrong project id.
  Future<ConnectionResult> testConnection({
    required String baseUrl,
    required String projectId,
    required String clientId,
    required String clientSecret,
  }) async {
    final api = OpenPanelApi(
      ApiCredentials(
        // Normalised exactly like saveProject, so the URL that was tested is the
        // URL that gets stored (a trailing slash used to make them differ).
        baseUrl: normalizeBaseUrl(baseUrl),
        clientId: clientId.trim(),
        clientSecret: clientSecret.trim(),
      ),
    );
    try {
      final data = await api.get(
        ApiConstants.exportEvents,
        query: {'projectId': projectId.trim(), 'limit': 1},
      );
      if (data is! Map || data['data'] is! List) {
        throw const ApiException(
          ApiErrorKind.notFound,
          'That URL answered, but not like an OpenPanel API. Check the Base URL '
          '(for self-hosted it\'s usually https://your-domain/api or https://api.your-domain).',
        );
      }
      final meta = data['meta'];
      return ConnectionResult(
        totalEvents: meta is Map ? (meta['totalCount'] as num?)?.toInt() : null,
      );
    } finally {
      api.close();
    }
  }

  /// Persists a project: secrets to secure storage, the rest to Hive.
  Future<ProjectConfig> saveProject({
    String? existingId,
    DateTime? createdAt,
    required String name,
    required String baseUrl,
    required String projectId,
    required String clientId,
    required String clientSecret,
  }) async {
    final id = existingId ?? _newId();
    await _secure.saveCredentials(
      projectKey: id,
      clientId: clientId.trim(),
      clientSecret: clientSecret.trim(),
    );
    final config = ProjectConfig(
      id: id,
      name: name.trim().isEmpty ? projectId.trim() : name.trim(),
      baseUrl: normalizeBaseUrl(baseUrl),
      projectId: projectId.trim(),
      createdAt: createdAt ?? DateTime.now(),
    );
    await _projects.upsert(config);
    return config;
  }

  Future<String?> readClientId(String projectKey) async =>
      (await _secure.readCredentials(projectKey))?.clientId;

  static String _newId() {
    final r = Random.secure();
    return List.generate(12, (_) => r.nextInt(36).toRadixString(36)).join();
  }
}

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(
  ref.watch(secureStorageProvider),
  ref.read(projectsProvider.notifier),
);
