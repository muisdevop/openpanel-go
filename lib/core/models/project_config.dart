import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_config.freezed.dart';
part 'project_config.g.dart';

/// A saved OpenPanel project. Non-secret fields only: this lives in Hive.
/// The client ID and secret live in flutter_secure_storage, keyed by [id].
@freezed
abstract class ProjectConfig with _$ProjectConfig {
  const factory ProjectConfig({
    /// Local identifier (not the OpenPanel project id).
    required String id,
    required String name,
    required String baseUrl,
    required String projectId,
    required DateTime createdAt,
  }) = _ProjectConfig;

  factory ProjectConfig.fromJson(Map<String, dynamic> json) =>
      _$ProjectConfigFromJson(json);
}
