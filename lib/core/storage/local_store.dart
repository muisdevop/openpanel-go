import 'dart:async';
import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/date_range.dart';
import '../models/project_config.dart';

/// Non-secret persistence in Hive: the project list, the active project,
/// the selected date range and a small response cache.
class LocalStore {
  LocalStore._(this._projects, this._settings, this._cache);

  static const _projectsBox = 'projects';
  static const _settingsBox = 'settings';
  static const _cacheBox = 'cache';

  final Box<String> _projects;
  final Box<String> _settings;
  final Box<String> _cache;

  /// Opens the three boxes. [hiveDir] bypasses `initFlutter`, which needs the
  /// path_provider plugin — tests and any non-Flutter entry point pass a
  /// directory instead.
  static Future<LocalStore> open({String? hiveDir}) async {
    if (hiveDir == null) {
      await Hive.initFlutter('openpanel_go');
    } else {
      Hive.init(hiveDir);
    }
    final results = await Future.wait([
      Hive.openBox<String>(_projectsBox),
      Hive.openBox<String>(_settingsBox),
      Hive.openBox<String>(_cacheBox),
    ]);
    return LocalStore._(results[0], results[1], results[2]);
  }

  // Projects ---------------------------------------------------------------

  List<ProjectConfig> readProjects() {
    final list = <ProjectConfig>[];
    for (final raw in _projects.values) {
      try {
        list.add(
          ProjectConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>),
        );
      } catch (_) {
        // Skip corrupt entries rather than crash.
      }
    }
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  Future<void> upsertProject(ProjectConfig p) =>
      _projects.put(p.id, jsonEncode(p.toJson()));

  Future<void> deleteProject(String id) async {
    await _projects.delete(id);
    // Metrics cache keys are namespaced by project id. Without this, a deleted
    // project's traffic numbers stay on disk in an unencrypted box forever.
    final prefix = 'metrics:$id:';
    for (final key in _cache.keys.whereType<String>().toList()) {
      if (key.startsWith(prefix)) await _cache.delete(key);
    }
  }

  // Settings ---------------------------------------------------------------

  String? get activeProjectId => _settings.get('active_project');
  Future<void> setActiveProjectId(String? id) => id == null
      ? _settings.delete('active_project')
      : _settings.put('active_project', id);

  SelectedDateRange get dateRange {
    final raw = _settings.get('date_range');
    if (raw == null) {
      return const SelectedDateRange.preset(DateRangePreset.last7Days);
    }
    try {
      return SelectedDateRange.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const SelectedDateRange.preset(DateRangePreset.last7Days);
    }
  }

  Future<void> setDateRange(SelectedDateRange r) =>
      _settings.put('date_range', jsonEncode(r.toJson()));

  // Cache ------------------------------------------------------------------

  /// Cached responses expire. Preset ranges encode no calendar dates in their
  /// cache key (`metrics:<id>:{"preset":"last7Days"}`), so without a TTL an
  /// offline launch weeks later would serve a weeks-old snapshot as "current".
  static const cacheMaxAge = Duration(hours: 24);

  /// Upper bound on cached entries: project × range × screen accumulates
  /// unboundedly otherwise, and the box is stored unencrypted on disk.
  static const _cacheMaxEntries = 200;

  String? readCache(String key, {Duration maxAge = cacheMaxAge}) {
    final raw = _cache.get(key);
    if (raw == null) return null;
    final value = _unwrap(raw, maxAge);
    if (value == null) {
      // Expired or unreadable envelope. `readCache` runs inside provider
      // builds and stays synchronous, so the delete can't be awaited. Losing it
      // costs only space: `_pruneCache` collects the same set (null stamp or
      // age > maxAge) on the next write, and nothing serves this key meanwhile.
      unawaited(_cache.delete(key));
    }
    return value;
  }

  Future<void> writeCache(String key, String value) async {
    await _cache.put(key, _wrap(value));
    await _pruneCache();
  }

  Future<int> clearCache() => _cache.clear();

  /// Drops expired entries, then evicts oldest-first until back under the cap.
  Future<void> _pruneCache() async {
    final expired = <dynamic>[];
    final ages = <String, int>{};
    for (final key in _cache.keys) {
      final stamp = _stampOf(_cache.get(key));
      if (stamp == null ||
          DateTime.now().difference(
                DateTime.fromMillisecondsSinceEpoch(stamp),
              ) >
              cacheMaxAge) {
        expired.add(key);
      } else {
        ages[key.toString()] = stamp;
      }
    }
    for (final key in expired) {
      await _cache.delete(key);
    }
    var excess = ages.length - _cacheMaxEntries;
    if (excess <= 0) return;
    final oldest = ages.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    for (final e in oldest) {
      if (excess <= 0) break;
      await _cache.delete(e.key);
      excess--;
    }
  }

  static const _stampKey = 't';
  static const _valueKey = 'v';

  static String _wrap(String value) => jsonEncode({
    _stampKey: DateTime.now().millisecondsSinceEpoch,
    _valueKey: value,
  });

  /// Returns null for anything unreadable, including the bare-JSON entries
  /// written before envelopes existed — those must not be served undated.
  static String? _unwrap(String raw, Duration maxAge) {
    try {
      final env = jsonDecode(raw) as Map<String, dynamic>;
      final stamp = env[_stampKey];
      final value = env[_valueKey];
      if (stamp is! num || value is! String) return null;
      final age = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(stamp.toInt()),
      );
      return age > maxAge ? null : value;
    } catch (_) {
      return null;
    }
  }

  static int? _stampOf(String? raw) {
    if (raw == null) return null;
    try {
      final stamp = (jsonDecode(raw) as Map)[_stampKey];
      return stamp is num ? stamp.toInt() : null;
    } catch (_) {
      return null;
    }
  }

  /// Log out: forget every project and setting.
  Future<void> clearAll() async {
    await _projects.clear();
    await _settings.clear();
    await _cache.clear();
  }
}
