// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventGeo {

 String? get country; String? get region; String? get city; double? get latitude; double? get longitude;
/// Create a copy of EventGeo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventGeoCopyWith<EventGeo> get copyWith => _$EventGeoCopyWithImpl<EventGeo>(this as EventGeo, _$identity);

  /// Serializes this EventGeo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventGeo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventGeo&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventGeo;
  return Object.hash(runtimeType,_this.country,_this.region,_this.city,_this.latitude,_this.longitude);
}

@override
String toString() {
  final _this = this as EventGeo;
  return 'EventGeo(country: ${_this.country}, region: ${_this.region}, city: ${_this.city}, latitude: ${_this.latitude}, longitude: ${_this.longitude})';
}


}

/// @nodoc
abstract mixin class $EventGeoCopyWith<$Res>  {
  factory $EventGeoCopyWith(EventGeo value, $Res Function(EventGeo) _then) = _$EventGeoCopyWithImpl;
@useResult
$Res call({
 String? country, String? region, String? city, double? latitude, double? longitude
});




}
/// @nodoc
class _$EventGeoCopyWithImpl<$Res>
    implements $EventGeoCopyWith<$Res> {
  _$EventGeoCopyWithImpl(this._self, this._then);

  final EventGeo _self;
  final $Res Function(EventGeo) _then;

/// Create a copy of EventGeo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? country = freezed,Object? region = freezed,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(EventGeo(
country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventGeo].
extension EventGeoPatterns on EventGeo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventGeo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventGeo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventGeo value)  $default,){
final _that = this;
switch (_that) {
case _EventGeo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventGeo value)?  $default,){
final _that = this;
switch (_that) {
case _EventGeo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? country,  String? region,  String? city,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventGeo() when $default != null:
return $default(_that.country,_that.region,_that.city,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? country,  String? region,  String? city,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _EventGeo():
return $default(_that.country,_that.region,_that.city,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? country,  String? region,  String? city,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _EventGeo() when $default != null:
return $default(_that.country,_that.region,_that.city,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventGeo implements EventGeo {
  const _EventGeo({this.country, this.region, this.city, this.latitude, this.longitude});
  factory _EventGeo.fromJson(Map<String, dynamic> json) => _$EventGeoFromJson(json);

@override final  String? country;
@override final  String? region;
@override final  String? city;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of EventGeo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventGeoCopyWith<_EventGeo> get copyWith => __$EventGeoCopyWithImpl<_EventGeo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventGeoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventGeo&&(identical(other.country, country) || other.country == country)&&(identical(other.region, region) || other.region == region)&&(identical(other.city, city) || other.city == city)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,country,region,city,latitude,longitude);
}

@override
String toString() {
    return 'EventGeo(country: $country, region: $region, city: $city, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$EventGeoCopyWith<$Res> implements $EventGeoCopyWith<$Res> {
  factory _$EventGeoCopyWith(_EventGeo value, $Res Function(_EventGeo) _then) = __$EventGeoCopyWithImpl;
@override @useResult
$Res call({
 String? country, String? region, String? city, double? latitude, double? longitude
});




}
/// @nodoc
class __$EventGeoCopyWithImpl<$Res>
    implements _$EventGeoCopyWith<$Res> {
  __$EventGeoCopyWithImpl(this._self, this._then);

  final _EventGeo _self;
  final $Res Function(_EventGeo) _then;

/// Create a copy of EventGeo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? country = freezed,Object? region = freezed,Object? city = freezed,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_EventGeo(
country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$EventDevice {

 String? get device; String? get os; String? get osVersion; String? get browser; String? get browserVersion; String? get brand; String? get model;
/// Create a copy of EventDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDeviceCopyWith<EventDevice> get copyWith => _$EventDeviceCopyWithImpl<EventDevice>(this as EventDevice, _$identity);

  /// Serializes this EventDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDevice&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.os, _this.os) || other.os == _this.os)&&(identical(other.osVersion, _this.osVersion) || other.osVersion == _this.osVersion)&&(identical(other.browser, _this.browser) || other.browser == _this.browser)&&(identical(other.browserVersion, _this.browserVersion) || other.browserVersion == _this.browserVersion)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.model, _this.model) || other.model == _this.model));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventDevice;
  return Object.hash(runtimeType,_this.device,_this.os,_this.osVersion,_this.browser,_this.browserVersion,_this.brand,_this.model);
}

@override
String toString() {
  final _this = this as EventDevice;
  return 'EventDevice(device: ${_this.device}, os: ${_this.os}, osVersion: ${_this.osVersion}, browser: ${_this.browser}, browserVersion: ${_this.browserVersion}, brand: ${_this.brand}, model: ${_this.model})';
}


}

/// @nodoc
abstract mixin class $EventDeviceCopyWith<$Res>  {
  factory $EventDeviceCopyWith(EventDevice value, $Res Function(EventDevice) _then) = _$EventDeviceCopyWithImpl;
@useResult
$Res call({
 String? device, String? os, String? osVersion, String? browser, String? browserVersion, String? brand, String? model
});




}
/// @nodoc
class _$EventDeviceCopyWithImpl<$Res>
    implements $EventDeviceCopyWith<$Res> {
  _$EventDeviceCopyWithImpl(this._self, this._then);

  final EventDevice _self;
  final $Res Function(EventDevice) _then;

/// Create a copy of EventDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = freezed,Object? os = freezed,Object? osVersion = freezed,Object? browser = freezed,Object? browserVersion = freezed,Object? brand = freezed,Object? model = freezed,}) {
  return _then(EventDevice(
device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,os: freezed == os ? _self.os : os // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,browser: freezed == browser ? _self.browser : browser // ignore: cast_nullable_to_non_nullable
as String?,browserVersion: freezed == browserVersion ? _self.browserVersion : browserVersion // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventDevice].
extension EventDevicePatterns on EventDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDevice value)  $default,){
final _that = this;
switch (_that) {
case _EventDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDevice value)?  $default,){
final _that = this;
switch (_that) {
case _EventDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? device,  String? os,  String? osVersion,  String? browser,  String? browserVersion,  String? brand,  String? model)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDevice() when $default != null:
return $default(_that.device,_that.os,_that.osVersion,_that.browser,_that.browserVersion,_that.brand,_that.model);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? device,  String? os,  String? osVersion,  String? browser,  String? browserVersion,  String? brand,  String? model)  $default,) {final _that = this;
switch (_that) {
case _EventDevice():
return $default(_that.device,_that.os,_that.osVersion,_that.browser,_that.browserVersion,_that.brand,_that.model);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? device,  String? os,  String? osVersion,  String? browser,  String? browserVersion,  String? brand,  String? model)?  $default,) {final _that = this;
switch (_that) {
case _EventDevice() when $default != null:
return $default(_that.device,_that.os,_that.osVersion,_that.browser,_that.browserVersion,_that.brand,_that.model);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventDevice extends EventDevice {
  const _EventDevice({this.device, this.os, this.osVersion, this.browser, this.browserVersion, this.brand, this.model}): super._();
  factory _EventDevice.fromJson(Map<String, dynamic> json) => _$EventDeviceFromJson(json);

@override final  String? device;
@override final  String? os;
@override final  String? osVersion;
@override final  String? browser;
@override final  String? browserVersion;
@override final  String? brand;
@override final  String? model;

/// Create a copy of EventDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDeviceCopyWith<_EventDevice> get copyWith => __$EventDeviceCopyWithImpl<_EventDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDevice&&(identical(other.device, device) || other.device == device)&&(identical(other.os, os) || other.os == os)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.browser, browser) || other.browser == browser)&&(identical(other.browserVersion, browserVersion) || other.browserVersion == browserVersion)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,device,os,osVersion,browser,browserVersion,brand,model);
}

@override
String toString() {
    return 'EventDevice(device: $device, os: $os, osVersion: $osVersion, browser: $browser, browserVersion: $browserVersion, brand: $brand, model: $model)';
}


}

/// @nodoc
abstract mixin class _$EventDeviceCopyWith<$Res> implements $EventDeviceCopyWith<$Res> {
  factory _$EventDeviceCopyWith(_EventDevice value, $Res Function(_EventDevice) _then) = __$EventDeviceCopyWithImpl;
@override @useResult
$Res call({
 String? device, String? os, String? osVersion, String? browser, String? browserVersion, String? brand, String? model
});




}
/// @nodoc
class __$EventDeviceCopyWithImpl<$Res>
    implements _$EventDeviceCopyWith<$Res> {
  __$EventDeviceCopyWithImpl(this._self, this._then);

  final _EventDevice _self;
  final $Res Function(_EventDevice) _then;

/// Create a copy of EventDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = freezed,Object? os = freezed,Object? osVersion = freezed,Object? browser = freezed,Object? browserVersion = freezed,Object? brand = freezed,Object? model = freezed,}) {
  return _then(_EventDevice(
device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String?,os: freezed == os ? _self.os : os // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,browser: freezed == browser ? _self.browser : browser // ignore: cast_nullable_to_non_nullable
as String?,browserVersion: freezed == browserVersion ? _self.browserVersion : browserVersion // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EventReferrer {

 String? get url; String? get name; String? get type;
/// Create a copy of EventReferrer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventReferrerCopyWith<EventReferrer> get copyWith => _$EventReferrerCopyWithImpl<EventReferrer>(this as EventReferrer, _$identity);

  /// Serializes this EventReferrer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventReferrer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventReferrer&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventReferrer;
  return Object.hash(runtimeType,_this.url,_this.name,_this.type);
}

@override
String toString() {
  final _this = this as EventReferrer;
  return 'EventReferrer(url: ${_this.url}, name: ${_this.name}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $EventReferrerCopyWith<$Res>  {
  factory $EventReferrerCopyWith(EventReferrer value, $Res Function(EventReferrer) _then) = _$EventReferrerCopyWithImpl;
@useResult
$Res call({
 String? url, String? name, String? type
});




}
/// @nodoc
class _$EventReferrerCopyWithImpl<$Res>
    implements $EventReferrerCopyWith<$Res> {
  _$EventReferrerCopyWithImpl(this._self, this._then);

  final EventReferrer _self;
  final $Res Function(EventReferrer) _then;

/// Create a copy of EventReferrer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? name = freezed,Object? type = freezed,}) {
  return _then(EventReferrer(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventReferrer].
extension EventReferrerPatterns on EventReferrer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventReferrer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventReferrer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventReferrer value)  $default,){
final _that = this;
switch (_that) {
case _EventReferrer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventReferrer value)?  $default,){
final _that = this;
switch (_that) {
case _EventReferrer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? url,  String? name,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventReferrer() when $default != null:
return $default(_that.url,_that.name,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? url,  String? name,  String? type)  $default,) {final _that = this;
switch (_that) {
case _EventReferrer():
return $default(_that.url,_that.name,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? url,  String? name,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _EventReferrer() when $default != null:
return $default(_that.url,_that.name,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventReferrer implements EventReferrer {
  const _EventReferrer({this.url, this.name, this.type});
  factory _EventReferrer.fromJson(Map<String, dynamic> json) => _$EventReferrerFromJson(json);

@override final  String? url;
@override final  String? name;
@override final  String? type;

/// Create a copy of EventReferrer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventReferrerCopyWith<_EventReferrer> get copyWith => __$EventReferrerCopyWithImpl<_EventReferrer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventReferrerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventReferrer&&(identical(other.url, url) || other.url == url)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,url,name,type);
}

@override
String toString() {
    return 'EventReferrer(url: $url, name: $name, type: $type)';
}


}

/// @nodoc
abstract mixin class _$EventReferrerCopyWith<$Res> implements $EventReferrerCopyWith<$Res> {
  factory _$EventReferrerCopyWith(_EventReferrer value, $Res Function(_EventReferrer) _then) = __$EventReferrerCopyWithImpl;
@override @useResult
$Res call({
 String? url, String? name, String? type
});




}
/// @nodoc
class __$EventReferrerCopyWithImpl<$Res>
    implements _$EventReferrerCopyWith<$Res> {
  __$EventReferrerCopyWithImpl(this._self, this._then);

  final _EventReferrer _self;
  final $Res Function(_EventReferrer) _then;

/// Create a copy of EventReferrer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? name = freezed,Object? type = freezed,}) {
  return _then(_EventReferrer(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EventProfile {

 String get id; String? get firstName; String? get lastName; String? get email; String? get avatar; bool get isExternal; Map<String, dynamic> get properties;
/// Create a copy of EventProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventProfileCopyWith<EventProfile> get copyWith => _$EventProfileCopyWithImpl<EventProfile>(this as EventProfile, _$identity);

  /// Serializes this EventProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.avatar, _this.avatar) || other.avatar == _this.avatar)&&(identical(other.isExternal, _this.isExternal) || other.isExternal == _this.isExternal)&&const DeepCollectionEquality().equals(other.properties, _this.properties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventProfile;
  return Object.hash(runtimeType,_this.id,_this.firstName,_this.lastName,_this.email,_this.avatar,_this.isExternal,const DeepCollectionEquality().hash(_this.properties));
}

@override
String toString() {
  final _this = this as EventProfile;
  return 'EventProfile(id: ${_this.id}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, email: ${_this.email}, avatar: ${_this.avatar}, isExternal: ${_this.isExternal}, properties: ${_this.properties})';
}


}

/// @nodoc
abstract mixin class $EventProfileCopyWith<$Res>  {
  factory $EventProfileCopyWith(EventProfile value, $Res Function(EventProfile) _then) = _$EventProfileCopyWithImpl;
@useResult
$Res call({
 String id, String? firstName, String? lastName, String? email, String? avatar, bool isExternal, Map<String, dynamic> properties
});




}
/// @nodoc
class _$EventProfileCopyWithImpl<$Res>
    implements $EventProfileCopyWith<$Res> {
  _$EventProfileCopyWithImpl(this._self, this._then);

  final EventProfile _self;
  final $Res Function(EventProfile) _then;

/// Create a copy of EventProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? avatar = freezed,Object? isExternal = null,Object? properties = null,}) {
  return _then(EventProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,isExternal: null == isExternal ? _self.isExternal : isExternal // ignore: cast_nullable_to_non_nullable
as bool,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [EventProfile].
extension EventProfilePatterns on EventProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventProfile value)  $default,){
final _that = this;
switch (_that) {
case _EventProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventProfile value)?  $default,){
final _that = this;
switch (_that) {
case _EventProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? firstName,  String? lastName,  String? email,  String? avatar,  bool isExternal,  Map<String, dynamic> properties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventProfile() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.avatar,_that.isExternal,_that.properties);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? firstName,  String? lastName,  String? email,  String? avatar,  bool isExternal,  Map<String, dynamic> properties)  $default,) {final _that = this;
switch (_that) {
case _EventProfile():
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.avatar,_that.isExternal,_that.properties);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? firstName,  String? lastName,  String? email,  String? avatar,  bool isExternal,  Map<String, dynamic> properties)?  $default,) {final _that = this;
switch (_that) {
case _EventProfile() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.email,_that.avatar,_that.isExternal,_that.properties);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventProfile extends EventProfile {
  const _EventProfile({required this.id, this.firstName, this.lastName, this.email, this.avatar, this.isExternal = false,  Map<String, dynamic> properties = const {}}): _properties = properties,super._();
  factory _EventProfile.fromJson(Map<String, dynamic> json) => _$EventProfileFromJson(json);

@override final  String id;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? email;
@override final  String? avatar;
@override@JsonKey() final  bool isExternal;
 final  Map<String, dynamic> _properties;
@override@JsonKey() Map<String, dynamic> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}


/// Create a copy of EventProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventProfileCopyWith<_EventProfile> get copyWith => __$EventProfileCopyWithImpl<_EventProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.isExternal, isExternal) || other.isExternal == isExternal)&&const DeepCollectionEquality().equals(other.properties, _properties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,firstName,lastName,email,avatar,isExternal,const DeepCollectionEquality().hash(_properties));
}

@override
String toString() {
    return 'EventProfile(id: $id, firstName: $firstName, lastName: $lastName, email: $email, avatar: $avatar, isExternal: $isExternal, properties: $properties)';
}


}

/// @nodoc
abstract mixin class _$EventProfileCopyWith<$Res> implements $EventProfileCopyWith<$Res> {
  factory _$EventProfileCopyWith(_EventProfile value, $Res Function(_EventProfile) _then) = __$EventProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String? firstName, String? lastName, String? email, String? avatar, bool isExternal, Map<String, dynamic> properties
});




}
/// @nodoc
class __$EventProfileCopyWithImpl<$Res>
    implements _$EventProfileCopyWith<$Res> {
  __$EventProfileCopyWithImpl(this._self, this._then);

  final _EventProfile _self;
  final $Res Function(_EventProfile) _then;

/// Create a copy of EventProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? email = freezed,Object? avatar = freezed,Object? isExternal = null,Object? properties = null,}) {
  return _then(_EventProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,isExternal: null == isExternal ? _self.isExternal : isExternal // ignore: cast_nullable_to_non_nullable
as bool,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$OpenPanelEvent {

 String get id; String get name; DateTime get timestamp; Map<String, dynamic> get properties; EventProfile? get profile; EventDevice get device; EventGeo get geo; EventReferrer get referrer; String? get path; String? get origin; String? get profileId; String? get deviceId; String? get sessionId; double? get duration; String? get sdkName; String? get sdkVersion;
/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenPanelEventCopyWith<OpenPanelEvent> get copyWith => _$OpenPanelEventCopyWithImpl<OpenPanelEvent>(this as OpenPanelEvent, _$identity);

  /// Serializes this OpenPanelEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OpenPanelEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenPanelEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&const DeepCollectionEquality().equals(other.properties, _this.properties)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.geo, _this.geo) || other.geo == _this.geo)&&(identical(other.referrer, _this.referrer) || other.referrer == _this.referrer)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.origin, _this.origin) || other.origin == _this.origin)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.sdkName, _this.sdkName) || other.sdkName == _this.sdkName)&&(identical(other.sdkVersion, _this.sdkVersion) || other.sdkVersion == _this.sdkVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OpenPanelEvent;
  return Object.hash(runtimeType,_this.id,_this.name,_this.timestamp,const DeepCollectionEquality().hash(_this.properties),_this.profile,_this.device,_this.geo,_this.referrer,_this.path,_this.origin,_this.profileId,_this.deviceId,_this.sessionId,_this.duration,_this.sdkName,_this.sdkVersion);
}

@override
String toString() {
  final _this = this as OpenPanelEvent;
  return 'OpenPanelEvent(id: ${_this.id}, name: ${_this.name}, timestamp: ${_this.timestamp}, properties: ${_this.properties}, profile: ${_this.profile}, device: ${_this.device}, geo: ${_this.geo}, referrer: ${_this.referrer}, path: ${_this.path}, origin: ${_this.origin}, profileId: ${_this.profileId}, deviceId: ${_this.deviceId}, sessionId: ${_this.sessionId}, duration: ${_this.duration}, sdkName: ${_this.sdkName}, sdkVersion: ${_this.sdkVersion})';
}


}

/// @nodoc
abstract mixin class $OpenPanelEventCopyWith<$Res>  {
  factory $OpenPanelEventCopyWith(OpenPanelEvent value, $Res Function(OpenPanelEvent) _then) = _$OpenPanelEventCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime timestamp, Map<String, dynamic> properties, EventProfile? profile, EventDevice device, EventGeo geo, EventReferrer referrer, String? path, String? origin, String? profileId, String? deviceId, String? sessionId, double? duration, String? sdkName, String? sdkVersion
});


$EventProfileCopyWith<$Res>? get profile;$EventDeviceCopyWith<$Res> get device;$EventGeoCopyWith<$Res> get geo;$EventReferrerCopyWith<$Res> get referrer;

}
/// @nodoc
class _$OpenPanelEventCopyWithImpl<$Res>
    implements $OpenPanelEventCopyWith<$Res> {
  _$OpenPanelEventCopyWithImpl(this._self, this._then);

  final OpenPanelEvent _self;
  final $Res Function(OpenPanelEvent) _then;

/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? timestamp = null,Object? properties = null,Object? profile = freezed,Object? device = null,Object? geo = null,Object? referrer = null,Object? path = freezed,Object? origin = freezed,Object? profileId = freezed,Object? deviceId = freezed,Object? sessionId = freezed,Object? duration = freezed,Object? sdkName = freezed,Object? sdkVersion = freezed,}) {
  return _then(OpenPanelEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as EventProfile?,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as EventDevice,geo: null == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as EventGeo,referrer: null == referrer ? _self.referrer : referrer // ignore: cast_nullable_to_non_nullable
as EventReferrer,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,sdkName: freezed == sdkName ? _self.sdkName : sdkName // ignore: cast_nullable_to_non_nullable
as String?,sdkVersion: freezed == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $EventProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDeviceCopyWith<$Res> get device {
  
  return $EventDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventGeoCopyWith<$Res> get geo {
  
  return $EventGeoCopyWith<$Res>(_self.geo, (value) {
    return _then(_self.copyWith(geo: value));
  });
}/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventReferrerCopyWith<$Res> get referrer {
  
  return $EventReferrerCopyWith<$Res>(_self.referrer, (value) {
    return _then(_self.copyWith(referrer: value));
  });
}
}


/// Adds pattern-matching-related methods to [OpenPanelEvent].
extension OpenPanelEventPatterns on OpenPanelEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenPanelEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenPanelEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenPanelEvent value)  $default,){
final _that = this;
switch (_that) {
case _OpenPanelEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenPanelEvent value)?  $default,){
final _that = this;
switch (_that) {
case _OpenPanelEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime timestamp,  Map<String, dynamic> properties,  EventProfile? profile,  EventDevice device,  EventGeo geo,  EventReferrer referrer,  String? path,  String? origin,  String? profileId,  String? deviceId,  String? sessionId,  double? duration,  String? sdkName,  String? sdkVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenPanelEvent() when $default != null:
return $default(_that.id,_that.name,_that.timestamp,_that.properties,_that.profile,_that.device,_that.geo,_that.referrer,_that.path,_that.origin,_that.profileId,_that.deviceId,_that.sessionId,_that.duration,_that.sdkName,_that.sdkVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime timestamp,  Map<String, dynamic> properties,  EventProfile? profile,  EventDevice device,  EventGeo geo,  EventReferrer referrer,  String? path,  String? origin,  String? profileId,  String? deviceId,  String? sessionId,  double? duration,  String? sdkName,  String? sdkVersion)  $default,) {final _that = this;
switch (_that) {
case _OpenPanelEvent():
return $default(_that.id,_that.name,_that.timestamp,_that.properties,_that.profile,_that.device,_that.geo,_that.referrer,_that.path,_that.origin,_that.profileId,_that.deviceId,_that.sessionId,_that.duration,_that.sdkName,_that.sdkVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime timestamp,  Map<String, dynamic> properties,  EventProfile? profile,  EventDevice device,  EventGeo geo,  EventReferrer referrer,  String? path,  String? origin,  String? profileId,  String? deviceId,  String? sessionId,  double? duration,  String? sdkName,  String? sdkVersion)?  $default,) {final _that = this;
switch (_that) {
case _OpenPanelEvent() when $default != null:
return $default(_that.id,_that.name,_that.timestamp,_that.properties,_that.profile,_that.device,_that.geo,_that.referrer,_that.path,_that.origin,_that.profileId,_that.deviceId,_that.sessionId,_that.duration,_that.sdkName,_that.sdkVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpenPanelEvent extends OpenPanelEvent {
  const _OpenPanelEvent({required this.id, required this.name, required this.timestamp,  Map<String, dynamic> properties = const {}, this.profile, this.device = const EventDevice(), this.geo = const EventGeo(), this.referrer = const EventReferrer(), this.path, this.origin, this.profileId, this.deviceId, this.sessionId, this.duration, this.sdkName, this.sdkVersion}): _properties = properties,super._();
  factory _OpenPanelEvent.fromJson(Map<String, dynamic> json) => _$OpenPanelEventFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime timestamp;
 final  Map<String, dynamic> _properties;
@override@JsonKey() Map<String, dynamic> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

@override final  EventProfile? profile;
@override@JsonKey() final  EventDevice device;
@override@JsonKey() final  EventGeo geo;
@override@JsonKey() final  EventReferrer referrer;
@override final  String? path;
@override final  String? origin;
@override final  String? profileId;
@override final  String? deviceId;
@override final  String? sessionId;
@override final  double? duration;
@override final  String? sdkName;
@override final  String? sdkVersion;

/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenPanelEventCopyWith<_OpenPanelEvent> get copyWith => __$OpenPanelEventCopyWithImpl<_OpenPanelEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenPanelEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenPanelEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.properties, _properties)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.device, device) || other.device == device)&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.referrer, referrer) || other.referrer == referrer)&&(identical(other.path, path) || other.path == path)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.sdkName, sdkName) || other.sdkName == sdkName)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,timestamp,const DeepCollectionEquality().hash(_properties),profile,device,geo,referrer,path,origin,profileId,deviceId,sessionId,duration,sdkName,sdkVersion);
}

@override
String toString() {
    return 'OpenPanelEvent(id: $id, name: $name, timestamp: $timestamp, properties: $properties, profile: $profile, device: $device, geo: $geo, referrer: $referrer, path: $path, origin: $origin, profileId: $profileId, deviceId: $deviceId, sessionId: $sessionId, duration: $duration, sdkName: $sdkName, sdkVersion: $sdkVersion)';
}


}

/// @nodoc
abstract mixin class _$OpenPanelEventCopyWith<$Res> implements $OpenPanelEventCopyWith<$Res> {
  factory _$OpenPanelEventCopyWith(_OpenPanelEvent value, $Res Function(_OpenPanelEvent) _then) = __$OpenPanelEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime timestamp, Map<String, dynamic> properties, EventProfile? profile, EventDevice device, EventGeo geo, EventReferrer referrer, String? path, String? origin, String? profileId, String? deviceId, String? sessionId, double? duration, String? sdkName, String? sdkVersion
});


@override $EventProfileCopyWith<$Res>? get profile;@override $EventDeviceCopyWith<$Res> get device;@override $EventGeoCopyWith<$Res> get geo;@override $EventReferrerCopyWith<$Res> get referrer;

}
/// @nodoc
class __$OpenPanelEventCopyWithImpl<$Res>
    implements _$OpenPanelEventCopyWith<$Res> {
  __$OpenPanelEventCopyWithImpl(this._self, this._then);

  final _OpenPanelEvent _self;
  final $Res Function(_OpenPanelEvent) _then;

/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? timestamp = null,Object? properties = null,Object? profile = freezed,Object? device = null,Object? geo = null,Object? referrer = null,Object? path = freezed,Object? origin = freezed,Object? profileId = freezed,Object? deviceId = freezed,Object? sessionId = freezed,Object? duration = freezed,Object? sdkName = freezed,Object? sdkVersion = freezed,}) {
  return _then(_OpenPanelEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as EventProfile?,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as EventDevice,geo: null == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as EventGeo,referrer: null == referrer ? _self.referrer : referrer // ignore: cast_nullable_to_non_nullable
as EventReferrer,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,sdkName: freezed == sdkName ? _self.sdkName : sdkName // ignore: cast_nullable_to_non_nullable
as String?,sdkVersion: freezed == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $EventProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventDeviceCopyWith<$Res> get device {
  
  return $EventDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventGeoCopyWith<$Res> get geo {
  
  return $EventGeoCopyWith<$Res>(_self.geo, (value) {
    return _then(_self.copyWith(geo: value));
  });
}/// Create a copy of OpenPanelEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventReferrerCopyWith<$Res> get referrer {
  
  return $EventReferrerCopyWith<$Res>(_self.referrer, (value) {
    return _then(_self.copyWith(referrer: value));
  });
}
}

// dart format on
