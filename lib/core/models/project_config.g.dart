// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectConfig _$ProjectConfigFromJson(Map<String, dynamic> json) =>
    _ProjectConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      baseUrl: json['baseUrl'] as String,
      projectId: json['projectId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ProjectConfigToJson(_ProjectConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'baseUrl': instance.baseUrl,
      'projectId': instance.projectId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
