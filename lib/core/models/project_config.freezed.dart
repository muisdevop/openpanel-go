// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectConfig {

/// Local identifier (not the OpenPanel project id).
 String get id; String get name; String get baseUrl; String get projectId; DateTime get createdAt;
/// Create a copy of ProjectConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectConfigCopyWith<ProjectConfig> get copyWith => _$ProjectConfigCopyWithImpl<ProjectConfig>(this as ProjectConfig, _$identity);

  /// Serializes this ProjectConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProjectConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectConfig&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.baseUrl, _this.baseUrl) || other.baseUrl == _this.baseUrl)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProjectConfig;
  return Object.hash(runtimeType,_this.id,_this.name,_this.baseUrl,_this.projectId,_this.createdAt);
}

@override
String toString() {
  final _this = this as ProjectConfig;
  return 'ProjectConfig(id: ${_this.id}, name: ${_this.name}, baseUrl: ${_this.baseUrl}, projectId: ${_this.projectId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ProjectConfigCopyWith<$Res>  {
  factory $ProjectConfigCopyWith(ProjectConfig value, $Res Function(ProjectConfig) _then) = _$ProjectConfigCopyWithImpl;
@useResult
$Res call({
 String id, String name, String baseUrl, String projectId, DateTime createdAt
});




}
/// @nodoc
class _$ProjectConfigCopyWithImpl<$Res>
    implements $ProjectConfigCopyWith<$Res> {
  _$ProjectConfigCopyWithImpl(this._self, this._then);

  final ProjectConfig _self;
  final $Res Function(ProjectConfig) _then;

/// Create a copy of ProjectConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? baseUrl = null,Object? projectId = null,Object? createdAt = null,}) {
  return _then(ProjectConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectConfig].
extension ProjectConfigPatterns on ProjectConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectConfig value)  $default,){
final _that = this;
switch (_that) {
case _ProjectConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String baseUrl,  String projectId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectConfig() when $default != null:
return $default(_that.id,_that.name,_that.baseUrl,_that.projectId,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String baseUrl,  String projectId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProjectConfig():
return $default(_that.id,_that.name,_that.baseUrl,_that.projectId,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String baseUrl,  String projectId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProjectConfig() when $default != null:
return $default(_that.id,_that.name,_that.baseUrl,_that.projectId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectConfig implements ProjectConfig {
  const _ProjectConfig({required this.id, required this.name, required this.baseUrl, required this.projectId, required this.createdAt});
  factory _ProjectConfig.fromJson(Map<String, dynamic> json) => _$ProjectConfigFromJson(json);

/// Local identifier (not the OpenPanel project id).
@override final  String id;
@override final  String name;
@override final  String baseUrl;
@override final  String projectId;
@override final  DateTime createdAt;

/// Create a copy of ProjectConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectConfigCopyWith<_ProjectConfig> get copyWith => __$ProjectConfigCopyWithImpl<_ProjectConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,baseUrl,projectId,createdAt);
}

@override
String toString() {
    return 'ProjectConfig(id: $id, name: $name, baseUrl: $baseUrl, projectId: $projectId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProjectConfigCopyWith<$Res> implements $ProjectConfigCopyWith<$Res> {
  factory _$ProjectConfigCopyWith(_ProjectConfig value, $Res Function(_ProjectConfig) _then) = __$ProjectConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String baseUrl, String projectId, DateTime createdAt
});




}
/// @nodoc
class __$ProjectConfigCopyWithImpl<$Res>
    implements _$ProjectConfigCopyWith<$Res> {
  __$ProjectConfigCopyWithImpl(this._self, this._then);

  final _ProjectConfig _self;
  final $Res Function(_ProjectConfig) _then;

/// Create a copy of ProjectConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? baseUrl = null,Object? projectId = null,Object? createdAt = null,}) {
  return _then(_ProjectConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
