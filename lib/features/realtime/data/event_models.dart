import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/coerce.dart';
import '../../../core/utils/formatters.dart';

part 'event_models.freezed.dart';
part 'event_models.g.dart';

const redactedValue = '[redacted]';

const _identityKeys = ['firstName', 'lastName', 'email'];

/// Custom property names whose values customers treat as personal, whatever
/// the event otherwise looks like.
final _piiKey = RegExp(
  r'(e-?mail|phone|tel|name|ip|address|street|city|zip|postal|passport|ssn|'
  r'card|cvc|password|secret|token)',
  caseSensitive: false,
);

@freezed
abstract class EventGeo with _$EventGeo {
  const factory EventGeo({
    String? country,
    String? region,
    String? city,
    double? latitude,
    double? longitude,
  }) = _EventGeo;

  factory EventGeo.fromJson(Map<String, dynamic> json) =>
      _$EventGeoFromJson(json);
}

@freezed
abstract class EventDevice with _$EventDevice {
  const EventDevice._();

  const factory EventDevice({
    String? device,
    String? os,
    String? osVersion,
    String? browser,
    String? browserVersion,
    String? brand,
    String? model,
  }) = _EventDevice;

  factory EventDevice.fromJson(Map<String, dynamic> json) =>
      _$EventDeviceFromJson(json);

  /// "desktop" | "mobile" | "tablet" | other/unknown.
  String get kind => (device ?? '').toLowerCase();
  bool get isMobile => kind == 'mobile' || kind == 'tablet';
}

@freezed
abstract class EventReferrer with _$EventReferrer {
  const factory EventReferrer({String? url, String? name, String? type}) =
      _EventReferrer;

  factory EventReferrer.fromJson(Map<String, dynamic> json) =>
      _$EventReferrerFromJson(json);
}

@freezed
abstract class EventProfile with _$EventProfile {
  const EventProfile._();

  const factory EventProfile({
    required String id,
    String? firstName,
    String? lastName,
    String? email,
    String? avatar,
    @Default(false) bool isExternal,
    @Default({}) Map<String, dynamic> properties,
  }) = _EventProfile;

  factory EventProfile.fromJson(Map<String, dynamic> json) =>
      _$EventProfileFromJson(json);

  String get displayName {
    final full = [
      firstName,
      lastName,
    ].where((s) => s != null && s.isNotEmpty).join(' ');
    if (full.isNotEmpty) return full;
    if (email != null && email!.isNotEmpty) return email!;
    return id;
  }
}

/// A raw event from `GET /export/events`.
@freezed
abstract class OpenPanelEvent with _$OpenPanelEvent {
  const OpenPanelEvent._();

  const factory OpenPanelEvent({
    required String id,
    required String name,
    required DateTime timestamp,
    @Default({}) Map<String, dynamic> properties,
    EventProfile? profile,
    @Default(EventDevice()) EventDevice device,
    @Default(EventGeo()) EventGeo geo,
    @Default(EventReferrer()) EventReferrer referrer,
    String? path,
    String? origin,
    String? profileId,
    String? deviceId,
    String? sessionId,
    double? duration,
    String? sdkName,
    String? sdkVersion,
  }) = _OpenPanelEvent;

  factory OpenPanelEvent.fromJson(Map<String, dynamic> json) =>
      _$OpenPanelEventFromJson(json);

  /// Maps the API's flat event object (createdAt, country, os, …).
  ///
  /// Throws [FormatException] when `createdAt` is unusable. A timestamp is the
  /// ordering key of a newest-first feed: substituting "now" would pin a stale
  /// event to the top forever, so the caller must drop the row instead.
  ///
  /// [ordinal] disambiguates synthesised ids. The server normally supplies one,
  /// but when it doesn't, `createdAt + name` collides for events in the same
  /// millisecond — and those ids are used as list keys.
  factory OpenPanelEvent.fromApi(Map<String, dynamic> j, {int ordinal = 0}) {
    String? s(String k) {
      final v = j[k];
      if (v == null) return null;
      final str = v.toString();
      return str.isEmpty ? null : str;
    }

    double? d(String k) {
      final v = j[k];
      if (v == null) return null;
      if (v is num) return v.toDouble();
      // Coordinates and durations have arrived as strings from some
      // self-hosted builds. A hard `as num?` there threw a TypeError that
      // killed the whole feed instead of this one field.
      return double.tryParse(v.toString());
    }

    final createdAt = parseApiDate(j['createdAt']);
    if (createdAt == null) {
      throw FormatException('Unparseable createdAt', j['createdAt']);
    }

    EventProfile? profile;
    final p = j['profile'];
    if (p is Map && p['id'] != null && p['id'].toString().isNotEmpty) {
      // Servers differ here: some flag the profile, some only carry an
      // external id. Either means the visitor is recognisable across devices.
      profile = EventProfile(
        id: p['id'].toString(),
        firstName: asString(p['firstName']),
        lastName: asString(p['lastName']),
        email: asString(p['email']),
        avatar: asString(p['avatar']),
        isExternal:
            p['isExternal'] == true ||
            (p['externalId']?.toString() ?? '').isNotEmpty ||
            (p['identifier']?.toString() ?? '').isNotEmpty,
        properties: p['properties'] is Map
            ? Map<String, dynamic>.from(p['properties'] as Map)
            : const {},
      );
    }

    return OpenPanelEvent(
      id: s('id') ?? '${j['createdAt']}-${j['name']}-$ordinal',
      name: s('name') ?? 'unknown',
      timestamp: createdAt.toLocal(),
      properties: j['properties'] is Map
          ? Map<String, dynamic>.from(j['properties'] as Map)
          : const {},
      profile: profile,
      device: EventDevice(
        device: s('device'),
        os: s('os'),
        osVersion: s('osVersion'),
        browser: s('browser'),
        browserVersion: s('browserVersion'),
        brand: s('brand'),
        model: s('model'),
      ),
      geo: EventGeo(
        country: s('country'),
        region: s('region'),
        city: s('city'),
        latitude: d('latitude'),
        longitude: d('longitude'),
      ),
      referrer: EventReferrer(
        url: s('referrer'),
        name: s('referrerName'),
        type: s('referrerType'),
      ),
      path: s('path'),
      origin: s('origin'),
      profileId: s('profileId'),
      deviceId: s('deviceId'),
      sessionId: s('sessionId'),
      duration: d('duration'),
      sdkName: s('sdkName'),
      sdkVersion: s('sdkVersion'),
    );
  }

  /// Copy-safe view of the event.
  ///
  /// The clipboard is a shared surface: any app can read it, and OS clipboard
  /// sync can push the payload to other devices. Direct identifiers are dropped
  /// before the JSON leaves the screen. Pseudonymous ids stay — they're what
  /// makes a copied event usable for debugging.
  Map<String, dynamic> toShareableJson() {
    // `toJson()` is shallow: nested models stay as EventProfile/EventGeo
    // objects and are only expanded when the JSON encoder calls their own
    // toJson(). Round-tripping first gives a plain map tree to edit.
    final json = (jsonDecode(jsonEncode(toJson())) as Map)
        .cast<String, dynamic>();

    final profile = json['profile'];
    if (profile is Map) {
      final p = Map<String, dynamic>.from(profile)
        ..remove('avatar')
        ..remove('properties');
      for (final key in _identityKeys) {
        if (p.containsKey(key)) p[key] = redactedValue;
      }
      json['profile'] = p;
    }

    final geo = json['geo'];
    if (geo is Map) {
      json['geo'] = Map<String, dynamic>.from(geo)
        ..remove('latitude')
        ..remove('longitude');
    }

    final props = json['properties'];
    if (props is Map) {
      json['properties'] = {
        for (final e in props.entries)
          e.key: _piiKey.hasMatch('${e.key}') ? redactedValue : e.value,
      };
    }

    return json;
  }

  bool get isScreenView => name == 'screen_view';

  /// Identified = the event carries real identity data.
  ///
  /// OpenPanel assigns a `profileId` to anonymous events too, and it differs
  /// from `deviceId` by construction — so id inequality alone is true for
  /// essentially the whole feed and carries no information.
  bool get isIdentified {
    final p = profile;
    if (p == null) return false;
    if (p.isExternal) return true;
    if ((p.email ?? '').isNotEmpty) return true;
    return (p.firstName ?? '').isNotEmpty || (p.lastName ?? '').isNotEmpty;
  }

  /// Returns null instead of throwing when a payload is unusable, so the
  /// caller can skip the row and report how many were dropped.
  static OpenPanelEvent? tryFromApi(Map<String, dynamic> j, {int ordinal = 0}) {
    try {
      return OpenPanelEvent.fromApi(j, ordinal: ordinal);
    } on Object {
      // FormatException (bad createdAt) and TypeError (a field whose shape this
      // server version doesn't match) both mean one unusable row. Letting a
      // TypeError escape took down the entire feed, not the row.
      return null;
    }
  }
}

class EventFilters {
  const EventFilters({this.eventName, this.country, this.device});

  final String? eventName;
  final String? country;
  final String? device;

  bool get isEmpty => eventName == null && country == null && device == null;
  int get count => [eventName, country, device].where((e) => e != null).length;

  bool matches(OpenPanelEvent e) =>
      (eventName == null || e.name == eventName) &&
      (country == null || e.geo.country == country) &&
      (device == null || e.device.kind == device);

  EventFilters copyWith({
    String? Function()? eventName,
    String? Function()? country,
    String? Function()? device,
  }) => EventFilters(
    eventName: eventName != null ? eventName() : this.eventName,
    country: country != null ? country() : this.country,
    device: device != null ? device() : this.device,
  );
}
