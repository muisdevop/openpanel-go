// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventGeo _$EventGeoFromJson(Map<String, dynamic> json) => _EventGeo(
  country: json['country'] as String?,
  region: json['region'] as String?,
  city: json['city'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$EventGeoToJson(_EventGeo instance) => <String, dynamic>{
  'country': instance.country,
  'region': instance.region,
  'city': instance.city,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

_EventDevice _$EventDeviceFromJson(Map<String, dynamic> json) => _EventDevice(
  device: json['device'] as String?,
  os: json['os'] as String?,
  osVersion: json['osVersion'] as String?,
  browser: json['browser'] as String?,
  browserVersion: json['browserVersion'] as String?,
  brand: json['brand'] as String?,
  model: json['model'] as String?,
);

Map<String, dynamic> _$EventDeviceToJson(_EventDevice instance) =>
    <String, dynamic>{
      'device': instance.device,
      'os': instance.os,
      'osVersion': instance.osVersion,
      'browser': instance.browser,
      'browserVersion': instance.browserVersion,
      'brand': instance.brand,
      'model': instance.model,
    };

_EventReferrer _$EventReferrerFromJson(Map<String, dynamic> json) =>
    _EventReferrer(
      url: json['url'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$EventReferrerToJson(_EventReferrer instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'type': instance.type,
    };

_EventProfile _$EventProfileFromJson(Map<String, dynamic> json) =>
    _EventProfile(
      id: json['id'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      isExternal: json['isExternal'] as bool? ?? false,
      properties: json['properties'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$EventProfileToJson(_EventProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'avatar': instance.avatar,
      'isExternal': instance.isExternal,
      'properties': instance.properties,
    };

_OpenPanelEvent _$OpenPanelEventFromJson(Map<String, dynamic> json) =>
    _OpenPanelEvent(
      id: json['id'] as String,
      name: json['name'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      properties: json['properties'] as Map<String, dynamic>? ?? const {},
      profile: json['profile'] == null
          ? null
          : EventProfile.fromJson(json['profile'] as Map<String, dynamic>),
      device: json['device'] == null
          ? const EventDevice()
          : EventDevice.fromJson(json['device'] as Map<String, dynamic>),
      geo: json['geo'] == null
          ? const EventGeo()
          : EventGeo.fromJson(json['geo'] as Map<String, dynamic>),
      referrer: json['referrer'] == null
          ? const EventReferrer()
          : EventReferrer.fromJson(json['referrer'] as Map<String, dynamic>),
      path: json['path'] as String?,
      origin: json['origin'] as String?,
      profileId: json['profileId'] as String?,
      deviceId: json['deviceId'] as String?,
      sessionId: json['sessionId'] as String?,
      duration: (json['duration'] as num?)?.toDouble(),
      sdkName: json['sdkName'] as String?,
      sdkVersion: json['sdkVersion'] as String?,
    );

Map<String, dynamic> _$OpenPanelEventToJson(_OpenPanelEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'timestamp': instance.timestamp.toIso8601String(),
      'properties': instance.properties,
      'profile': instance.profile,
      'device': instance.device,
      'geo': instance.geo,
      'referrer': instance.referrer,
      'path': instance.path,
      'origin': instance.origin,
      'profileId': instance.profileId,
      'deviceId': instance.deviceId,
      'sessionId': instance.sessionId,
      'duration': instance.duration,
      'sdkName': instance.sdkName,
      'sdkVersion': instance.sdkVersion,
    };
