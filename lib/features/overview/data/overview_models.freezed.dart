// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overview_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetricsSnapshot {

 double get uniqueVisitors; double get totalSessions; double get totalScreenViews; double get bounceRate; double get avgSessionDuration; double get viewsPerSession;
/// Create a copy of MetricsSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetricsSnapshotCopyWith<MetricsSnapshot> get copyWith => _$MetricsSnapshotCopyWithImpl<MetricsSnapshot>(this as MetricsSnapshot, _$identity);

  /// Serializes this MetricsSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MetricsSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetricsSnapshot&&(identical(other.uniqueVisitors, _this.uniqueVisitors) || other.uniqueVisitors == _this.uniqueVisitors)&&(identical(other.totalSessions, _this.totalSessions) || other.totalSessions == _this.totalSessions)&&(identical(other.totalScreenViews, _this.totalScreenViews) || other.totalScreenViews == _this.totalScreenViews)&&(identical(other.bounceRate, _this.bounceRate) || other.bounceRate == _this.bounceRate)&&(identical(other.avgSessionDuration, _this.avgSessionDuration) || other.avgSessionDuration == _this.avgSessionDuration)&&(identical(other.viewsPerSession, _this.viewsPerSession) || other.viewsPerSession == _this.viewsPerSession));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MetricsSnapshot;
  return Object.hash(runtimeType,_this.uniqueVisitors,_this.totalSessions,_this.totalScreenViews,_this.bounceRate,_this.avgSessionDuration,_this.viewsPerSession);
}

@override
String toString() {
  final _this = this as MetricsSnapshot;
  return 'MetricsSnapshot(uniqueVisitors: ${_this.uniqueVisitors}, totalSessions: ${_this.totalSessions}, totalScreenViews: ${_this.totalScreenViews}, bounceRate: ${_this.bounceRate}, avgSessionDuration: ${_this.avgSessionDuration}, viewsPerSession: ${_this.viewsPerSession})';
}


}

/// @nodoc
abstract mixin class $MetricsSnapshotCopyWith<$Res>  {
  factory $MetricsSnapshotCopyWith(MetricsSnapshot value, $Res Function(MetricsSnapshot) _then) = _$MetricsSnapshotCopyWithImpl;
@useResult
$Res call({
 double uniqueVisitors, double totalSessions, double totalScreenViews, double bounceRate, double avgSessionDuration, double viewsPerSession
});




}
/// @nodoc
class _$MetricsSnapshotCopyWithImpl<$Res>
    implements $MetricsSnapshotCopyWith<$Res> {
  _$MetricsSnapshotCopyWithImpl(this._self, this._then);

  final MetricsSnapshot _self;
  final $Res Function(MetricsSnapshot) _then;

/// Create a copy of MetricsSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uniqueVisitors = null,Object? totalSessions = null,Object? totalScreenViews = null,Object? bounceRate = null,Object? avgSessionDuration = null,Object? viewsPerSession = null,}) {
  return _then(MetricsSnapshot(
uniqueVisitors: null == uniqueVisitors ? _self.uniqueVisitors : uniqueVisitors // ignore: cast_nullable_to_non_nullable
as double,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as double,totalScreenViews: null == totalScreenViews ? _self.totalScreenViews : totalScreenViews // ignore: cast_nullable_to_non_nullable
as double,bounceRate: null == bounceRate ? _self.bounceRate : bounceRate // ignore: cast_nullable_to_non_nullable
as double,avgSessionDuration: null == avgSessionDuration ? _self.avgSessionDuration : avgSessionDuration // ignore: cast_nullable_to_non_nullable
as double,viewsPerSession: null == viewsPerSession ? _self.viewsPerSession : viewsPerSession // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MetricsSnapshot].
extension MetricsSnapshotPatterns on MetricsSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetricsSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetricsSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetricsSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _MetricsSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetricsSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _MetricsSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double uniqueVisitors,  double totalSessions,  double totalScreenViews,  double bounceRate,  double avgSessionDuration,  double viewsPerSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MetricsSnapshot() when $default != null:
return $default(_that.uniqueVisitors,_that.totalSessions,_that.totalScreenViews,_that.bounceRate,_that.avgSessionDuration,_that.viewsPerSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double uniqueVisitors,  double totalSessions,  double totalScreenViews,  double bounceRate,  double avgSessionDuration,  double viewsPerSession)  $default,) {final _that = this;
switch (_that) {
case _MetricsSnapshot():
return $default(_that.uniqueVisitors,_that.totalSessions,_that.totalScreenViews,_that.bounceRate,_that.avgSessionDuration,_that.viewsPerSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double uniqueVisitors,  double totalSessions,  double totalScreenViews,  double bounceRate,  double avgSessionDuration,  double viewsPerSession)?  $default,) {final _that = this;
switch (_that) {
case _MetricsSnapshot() when $default != null:
return $default(_that.uniqueVisitors,_that.totalSessions,_that.totalScreenViews,_that.bounceRate,_that.avgSessionDuration,_that.viewsPerSession);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetricsSnapshot implements MetricsSnapshot {
  const _MetricsSnapshot({this.uniqueVisitors = 0, this.totalSessions = 0, this.totalScreenViews = 0, this.bounceRate = 0, this.avgSessionDuration = 0, this.viewsPerSession = 0});
  factory _MetricsSnapshot.fromJson(Map<String, dynamic> json) => _$MetricsSnapshotFromJson(json);

@override@JsonKey() final  double uniqueVisitors;
@override@JsonKey() final  double totalSessions;
@override@JsonKey() final  double totalScreenViews;
@override@JsonKey() final  double bounceRate;
@override@JsonKey() final  double avgSessionDuration;
@override@JsonKey() final  double viewsPerSession;

/// Create a copy of MetricsSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetricsSnapshotCopyWith<_MetricsSnapshot> get copyWith => __$MetricsSnapshotCopyWithImpl<_MetricsSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetricsSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetricsSnapshot&&(identical(other.uniqueVisitors, uniqueVisitors) || other.uniqueVisitors == uniqueVisitors)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalScreenViews, totalScreenViews) || other.totalScreenViews == totalScreenViews)&&(identical(other.bounceRate, bounceRate) || other.bounceRate == bounceRate)&&(identical(other.avgSessionDuration, avgSessionDuration) || other.avgSessionDuration == avgSessionDuration)&&(identical(other.viewsPerSession, viewsPerSession) || other.viewsPerSession == viewsPerSession));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uniqueVisitors,totalSessions,totalScreenViews,bounceRate,avgSessionDuration,viewsPerSession);
}

@override
String toString() {
    return 'MetricsSnapshot(uniqueVisitors: $uniqueVisitors, totalSessions: $totalSessions, totalScreenViews: $totalScreenViews, bounceRate: $bounceRate, avgSessionDuration: $avgSessionDuration, viewsPerSession: $viewsPerSession)';
}


}

/// @nodoc
abstract mixin class _$MetricsSnapshotCopyWith<$Res> implements $MetricsSnapshotCopyWith<$Res> {
  factory _$MetricsSnapshotCopyWith(_MetricsSnapshot value, $Res Function(_MetricsSnapshot) _then) = __$MetricsSnapshotCopyWithImpl;
@override @useResult
$Res call({
 double uniqueVisitors, double totalSessions, double totalScreenViews, double bounceRate, double avgSessionDuration, double viewsPerSession
});




}
/// @nodoc
class __$MetricsSnapshotCopyWithImpl<$Res>
    implements _$MetricsSnapshotCopyWith<$Res> {
  __$MetricsSnapshotCopyWithImpl(this._self, this._then);

  final _MetricsSnapshot _self;
  final $Res Function(_MetricsSnapshot) _then;

/// Create a copy of MetricsSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueVisitors = null,Object? totalSessions = null,Object? totalScreenViews = null,Object? bounceRate = null,Object? avgSessionDuration = null,Object? viewsPerSession = null,}) {
  return _then(_MetricsSnapshot(
uniqueVisitors: null == uniqueVisitors ? _self.uniqueVisitors : uniqueVisitors // ignore: cast_nullable_to_non_nullable
as double,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as double,totalScreenViews: null == totalScreenViews ? _self.totalScreenViews : totalScreenViews // ignore: cast_nullable_to_non_nullable
as double,bounceRate: null == bounceRate ? _self.bounceRate : bounceRate // ignore: cast_nullable_to_non_nullable
as double,avgSessionDuration: null == avgSessionDuration ? _self.avgSessionDuration : avgSessionDuration // ignore: cast_nullable_to_non_nullable
as double,viewsPerSession: null == viewsPerSession ? _self.viewsPerSession : viewsPerSession // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$OverviewMetrics {

 MetricsSnapshot get current; MetricsSnapshot? get previous; bool get fromCache;
/// Create a copy of OverviewMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverviewMetricsCopyWith<OverviewMetrics> get copyWith => _$OverviewMetricsCopyWithImpl<OverviewMetrics>(this as OverviewMetrics, _$identity);

  /// Serializes this OverviewMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OverviewMetrics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverviewMetrics&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.previous, _this.previous) || other.previous == _this.previous)&&(identical(other.fromCache, _this.fromCache) || other.fromCache == _this.fromCache));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OverviewMetrics;
  return Object.hash(runtimeType,_this.current,_this.previous,_this.fromCache);
}

@override
String toString() {
  final _this = this as OverviewMetrics;
  return 'OverviewMetrics(current: ${_this.current}, previous: ${_this.previous}, fromCache: ${_this.fromCache})';
}


}

/// @nodoc
abstract mixin class $OverviewMetricsCopyWith<$Res>  {
  factory $OverviewMetricsCopyWith(OverviewMetrics value, $Res Function(OverviewMetrics) _then) = _$OverviewMetricsCopyWithImpl;
@useResult
$Res call({
 MetricsSnapshot current, MetricsSnapshot? previous, bool fromCache
});


$MetricsSnapshotCopyWith<$Res> get current;$MetricsSnapshotCopyWith<$Res>? get previous;

}
/// @nodoc
class _$OverviewMetricsCopyWithImpl<$Res>
    implements $OverviewMetricsCopyWith<$Res> {
  _$OverviewMetricsCopyWithImpl(this._self, this._then);

  final OverviewMetrics _self;
  final $Res Function(OverviewMetrics) _then;

/// Create a copy of OverviewMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? previous = freezed,Object? fromCache = null,}) {
  return _then(OverviewMetrics(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as MetricsSnapshot,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as MetricsSnapshot?,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of OverviewMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetricsSnapshotCopyWith<$Res> get current {
  
  return $MetricsSnapshotCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of OverviewMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetricsSnapshotCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $MetricsSnapshotCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// Adds pattern-matching-related methods to [OverviewMetrics].
extension OverviewMetricsPatterns on OverviewMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverviewMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverviewMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverviewMetrics value)  $default,){
final _that = this;
switch (_that) {
case _OverviewMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverviewMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _OverviewMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MetricsSnapshot current,  MetricsSnapshot? previous,  bool fromCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverviewMetrics() when $default != null:
return $default(_that.current,_that.previous,_that.fromCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MetricsSnapshot current,  MetricsSnapshot? previous,  bool fromCache)  $default,) {final _that = this;
switch (_that) {
case _OverviewMetrics():
return $default(_that.current,_that.previous,_that.fromCache);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MetricsSnapshot current,  MetricsSnapshot? previous,  bool fromCache)?  $default,) {final _that = this;
switch (_that) {
case _OverviewMetrics() when $default != null:
return $default(_that.current,_that.previous,_that.fromCache);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OverviewMetrics implements OverviewMetrics {
  const _OverviewMetrics({required this.current, this.previous, this.fromCache = false});
  factory _OverviewMetrics.fromJson(Map<String, dynamic> json) => _$OverviewMetricsFromJson(json);

@override final  MetricsSnapshot current;
@override final  MetricsSnapshot? previous;
@override@JsonKey() final  bool fromCache;

/// Create a copy of OverviewMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverviewMetricsCopyWith<_OverviewMetrics> get copyWith => __$OverviewMetricsCopyWithImpl<_OverviewMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverviewMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverviewMetrics&&(identical(other.current, current) || other.current == current)&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,current,previous,fromCache);
}

@override
String toString() {
    return 'OverviewMetrics(current: $current, previous: $previous, fromCache: $fromCache)';
}


}

/// @nodoc
abstract mixin class _$OverviewMetricsCopyWith<$Res> implements $OverviewMetricsCopyWith<$Res> {
  factory _$OverviewMetricsCopyWith(_OverviewMetrics value, $Res Function(_OverviewMetrics) _then) = __$OverviewMetricsCopyWithImpl;
@override @useResult
$Res call({
 MetricsSnapshot current, MetricsSnapshot? previous, bool fromCache
});


@override $MetricsSnapshotCopyWith<$Res> get current;@override $MetricsSnapshotCopyWith<$Res>? get previous;

}
/// @nodoc
class __$OverviewMetricsCopyWithImpl<$Res>
    implements _$OverviewMetricsCopyWith<$Res> {
  __$OverviewMetricsCopyWithImpl(this._self, this._then);

  final _OverviewMetrics _self;
  final $Res Function(_OverviewMetrics) _then;

/// Create a copy of OverviewMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? previous = freezed,Object? fromCache = null,}) {
  return _then(_OverviewMetrics(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as MetricsSnapshot,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as MetricsSnapshot?,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of OverviewMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetricsSnapshotCopyWith<$Res> get current {
  
  return $MetricsSnapshotCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of OverviewMetrics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetricsSnapshotCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $MetricsSnapshotCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// @nodoc
mixin _$ChartData {

 DateTime get date; double get count; double? get previous; String? get breakdown;
/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChartDataCopyWith<ChartData> get copyWith => _$ChartDataCopyWithImpl<ChartData>(this as ChartData, _$identity);

  /// Serializes this ChartData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChartData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartData&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.previous, _this.previous) || other.previous == _this.previous)&&(identical(other.breakdown, _this.breakdown) || other.breakdown == _this.breakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChartData;
  return Object.hash(runtimeType,_this.date,_this.count,_this.previous,_this.breakdown);
}

@override
String toString() {
  final _this = this as ChartData;
  return 'ChartData(date: ${_this.date}, count: ${_this.count}, previous: ${_this.previous}, breakdown: ${_this.breakdown})';
}


}

/// @nodoc
abstract mixin class $ChartDataCopyWith<$Res>  {
  factory $ChartDataCopyWith(ChartData value, $Res Function(ChartData) _then) = _$ChartDataCopyWithImpl;
@useResult
$Res call({
 DateTime date, double count, double? previous, String? breakdown
});




}
/// @nodoc
class _$ChartDataCopyWithImpl<$Res>
    implements $ChartDataCopyWith<$Res> {
  _$ChartDataCopyWithImpl(this._self, this._then);

  final ChartData _self;
  final $Res Function(ChartData) _then;

/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? count = null,Object? previous = freezed,Object? breakdown = freezed,}) {
  return _then(ChartData(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as double,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as double?,breakdown: freezed == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChartData].
extension ChartDataPatterns on ChartData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChartData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChartData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChartData value)  $default,){
final _that = this;
switch (_that) {
case _ChartData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChartData value)?  $default,){
final _that = this;
switch (_that) {
case _ChartData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double count,  double? previous,  String? breakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChartData() when $default != null:
return $default(_that.date,_that.count,_that.previous,_that.breakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double count,  double? previous,  String? breakdown)  $default,) {final _that = this;
switch (_that) {
case _ChartData():
return $default(_that.date,_that.count,_that.previous,_that.breakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double count,  double? previous,  String? breakdown)?  $default,) {final _that = this;
switch (_that) {
case _ChartData() when $default != null:
return $default(_that.date,_that.count,_that.previous,_that.breakdown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChartData implements ChartData {
  const _ChartData({required this.date, required this.count, this.previous, this.breakdown});
  factory _ChartData.fromJson(Map<String, dynamic> json) => _$ChartDataFromJson(json);

@override final  DateTime date;
@override final  double count;
@override final  double? previous;
@override final  String? breakdown;

/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChartDataCopyWith<_ChartData> get copyWith => __$ChartDataCopyWithImpl<_ChartData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChartDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChartData&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count)&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,count,previous,breakdown);
}

@override
String toString() {
    return 'ChartData(date: $date, count: $count, previous: $previous, breakdown: $breakdown)';
}


}

/// @nodoc
abstract mixin class _$ChartDataCopyWith<$Res> implements $ChartDataCopyWith<$Res> {
  factory _$ChartDataCopyWith(_ChartData value, $Res Function(_ChartData) _then) = __$ChartDataCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double count, double? previous, String? breakdown
});




}
/// @nodoc
class __$ChartDataCopyWithImpl<$Res>
    implements _$ChartDataCopyWith<$Res> {
  __$ChartDataCopyWithImpl(this._self, this._then);

  final _ChartData _self;
  final $Res Function(_ChartData) _then;

/// Create a copy of ChartData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? count = null,Object? previous = freezed,Object? breakdown = freezed,}) {
  return _then(_ChartData(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as double,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as double?,breakdown: freezed == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$VisitorsChart {

 List<ChartData> get visitors; List<ChartData> get pageviews; String get interval;
/// Create a copy of VisitorsChart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitorsChartCopyWith<VisitorsChart> get copyWith => _$VisitorsChartCopyWithImpl<VisitorsChart>(this as VisitorsChart, _$identity);

  /// Serializes this VisitorsChart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VisitorsChart;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitorsChart&&const DeepCollectionEquality().equals(other.visitors, _this.visitors)&&const DeepCollectionEquality().equals(other.pageviews, _this.pageviews)&&(identical(other.interval, _this.interval) || other.interval == _this.interval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VisitorsChart;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.visitors),const DeepCollectionEquality().hash(_this.pageviews),_this.interval);
}

@override
String toString() {
  final _this = this as VisitorsChart;
  return 'VisitorsChart(visitors: ${_this.visitors}, pageviews: ${_this.pageviews}, interval: ${_this.interval})';
}


}

/// @nodoc
abstract mixin class $VisitorsChartCopyWith<$Res>  {
  factory $VisitorsChartCopyWith(VisitorsChart value, $Res Function(VisitorsChart) _then) = _$VisitorsChartCopyWithImpl;
@useResult
$Res call({
 List<ChartData> visitors, List<ChartData> pageviews, String interval
});




}
/// @nodoc
class _$VisitorsChartCopyWithImpl<$Res>
    implements $VisitorsChartCopyWith<$Res> {
  _$VisitorsChartCopyWithImpl(this._self, this._then);

  final VisitorsChart _self;
  final $Res Function(VisitorsChart) _then;

/// Create a copy of VisitorsChart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? visitors = null,Object? pageviews = null,Object? interval = null,}) {
  return _then(VisitorsChart(
visitors: null == visitors ? _self.visitors : visitors // ignore: cast_nullable_to_non_nullable
as List<ChartData>,pageviews: null == pageviews ? _self.pageviews : pageviews // ignore: cast_nullable_to_non_nullable
as List<ChartData>,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitorsChart].
extension VisitorsChartPatterns on VisitorsChart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitorsChart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitorsChart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitorsChart value)  $default,){
final _that = this;
switch (_that) {
case _VisitorsChart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitorsChart value)?  $default,){
final _that = this;
switch (_that) {
case _VisitorsChart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChartData> visitors,  List<ChartData> pageviews,  String interval)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitorsChart() when $default != null:
return $default(_that.visitors,_that.pageviews,_that.interval);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChartData> visitors,  List<ChartData> pageviews,  String interval)  $default,) {final _that = this;
switch (_that) {
case _VisitorsChart():
return $default(_that.visitors,_that.pageviews,_that.interval);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChartData> visitors,  List<ChartData> pageviews,  String interval)?  $default,) {final _that = this;
switch (_that) {
case _VisitorsChart() when $default != null:
return $default(_that.visitors,_that.pageviews,_that.interval);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VisitorsChart implements VisitorsChart {
  const _VisitorsChart({ List<ChartData> visitors = const [],  List<ChartData> pageviews = const [], this.interval = 'day'}): _visitors = visitors,_pageviews = pageviews;
  factory _VisitorsChart.fromJson(Map<String, dynamic> json) => _$VisitorsChartFromJson(json);

 final  List<ChartData> _visitors;
@override@JsonKey() List<ChartData> get visitors {
  if (_visitors is EqualUnmodifiableListView) return _visitors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visitors);
}

 final  List<ChartData> _pageviews;
@override@JsonKey() List<ChartData> get pageviews {
  if (_pageviews is EqualUnmodifiableListView) return _pageviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pageviews);
}

@override@JsonKey() final  String interval;

/// Create a copy of VisitorsChart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitorsChartCopyWith<_VisitorsChart> get copyWith => __$VisitorsChartCopyWithImpl<_VisitorsChart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VisitorsChartToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitorsChart&&const DeepCollectionEquality().equals(other.visitors, _visitors)&&const DeepCollectionEquality().equals(other.pageviews, _pageviews)&&(identical(other.interval, interval) || other.interval == interval));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_visitors),const DeepCollectionEquality().hash(_pageviews),interval);
}

@override
String toString() {
    return 'VisitorsChart(visitors: $visitors, pageviews: $pageviews, interval: $interval)';
}


}

/// @nodoc
abstract mixin class _$VisitorsChartCopyWith<$Res> implements $VisitorsChartCopyWith<$Res> {
  factory _$VisitorsChartCopyWith(_VisitorsChart value, $Res Function(_VisitorsChart) _then) = __$VisitorsChartCopyWithImpl;
@override @useResult
$Res call({
 List<ChartData> visitors, List<ChartData> pageviews, String interval
});




}
/// @nodoc
class __$VisitorsChartCopyWithImpl<$Res>
    implements _$VisitorsChartCopyWith<$Res> {
  __$VisitorsChartCopyWithImpl(this._self, this._then);

  final _VisitorsChart _self;
  final $Res Function(_VisitorsChart) _then;

/// Create a copy of VisitorsChart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? visitors = null,Object? pageviews = null,Object? interval = null,}) {
  return _then(_VisitorsChart(
visitors: null == visitors ? _self._visitors : visitors // ignore: cast_nullable_to_non_nullable
as List<ChartData>,pageviews: null == pageviews ? _self._pageviews : pageviews // ignore: cast_nullable_to_non_nullable
as List<ChartData>,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
