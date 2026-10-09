import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models/date_range.dart';
import 'models/project_config.dart';
import 'network/api_exception.dart';
import 'network/dio_client.dart';
import 'storage/local_store.dart';
import 'storage/secure_storage_service.dart';

part 'providers.g.dart';

/// Opened in main() and injected via ProviderScope overrides.
@Riverpod(keepAlive: true)
LocalStore localStore(Ref ref) =>
    throw UnimplementedError('localStoreProvider must be overridden in main()');

@Riverpod(keepAlive: true)
SecureStorageService secureStorage(Ref ref) => SecureStorageService();

/// All saved projects.
@Riverpod(keepAlive: true)
class Projects extends _$Projects {
  @override
  List<ProjectConfig> build() => ref.watch(localStoreProvider).readProjects();

  Future<void> upsert(ProjectConfig project) async {
    await ref.read(localStoreProvider).upsertProject(project);
    state = ref.read(localStoreProvider).readProjects();
  }

  Future<void> remove(String id) async {
    await ref.read(secureStorageProvider).deleteCredentials(id);
    await ref.read(localStoreProvider).deleteProject(id);
    state = ref.read(localStoreProvider).readProjects();
    // Compare against the *stored* id, not the provider: this assignment above
    // already made ActiveProjectId recompute, so reading it now returns the
    // fallback rather than the project we just deleted.
    if (ref.read(localStoreProvider).activeProjectId == id) {
      await ref
          .read(activeProjectIdProvider.notifier)
          .select(state.isEmpty ? null : state.first.id);
    }
  }

  /// Log out: wipe secrets, projects, settings and cache.
  Future<void> logout() async {
    await ref.read(secureStorageProvider).clearAll();
    await ref.read(localStoreProvider).clearAll();
    state = const [];
    await ref.read(activeProjectIdProvider.notifier).select(null);
  }
}

@Riverpod(keepAlive: true)
class ActiveProjectId extends _$ActiveProjectId {
  @override
  String? build() {
    final store = ref.watch(localStoreProvider);
    // watch, not read: every screen derives from this value, and a `read`
    // severs the edge so adding or deleting a project leaves the selection
    // stale until something else happens to poke it.
    final projects = ref.watch(projectsProvider);
    final saved = store.activeProjectId;
    if (saved != null && projects.any((p) => p.id == saved)) return saved;
    // Deterministic (projectsProvider sorts by createdAt), so it doesn't need
    // persisting — re-deriving it yields the same id on the next launch.
    return projects.isEmpty ? null : projects.first.id;
  }

  Future<void> select(String? id) async {
    state = id;
    // Awaiting matters: a dropped write here shows one project now and a
    // different one after a restart, with nothing on screen to explain it.
    //
    // The failure itself is not fatal — the in-memory selection is already
    // applied — and callers fire this from tap handlers that don't await, so a
    // throw would surface as an unhandled async error rather than a message.
    try {
      await ref.read(localStoreProvider).setActiveProjectId(id);
    } on Object catch (e) {
      debugPrint('activeProjectId persist failed: $e');
    }
  }
}

@Riverpod(keepAlive: true)
ProjectConfig? activeProject(Ref ref) {
  final id = ref.watch(activeProjectIdProvider);
  final projects = ref.watch(projectsProvider);
  for (final p in projects) {
    if (p.id == id) return p;
  }
  return projects.isEmpty ? null : projects.first;
}

/// The API client for the active project, rebuilt whenever it changes.
///
/// Null means "no project selected". A selected project whose secret is
/// missing is an [ApiException.noCredentials] — not null, because every
/// consumer had to re-derive that distinction and the screens that didn't
/// showed an empty feed instead of a fixable error.
@Riverpod(keepAlive: true)
Future<OpenPanelApi?> activeApi(Ref ref) async {
  final project = ref.watch(activeProjectProvider);
  if (project == null) return null;
  // A fresh client means new (or re-entered) credentials, so the previous
  // project's rejection no longer applies.
  final rejected = ref.read(credentialsRejectedProvider.notifier);
  rejected.clear();
  final creds = await ref
      .read(secureStorageProvider)
      .readCredentials(project.id);
  if (creds == null) throwNoCredentials();
  final api = OpenPanelApi(
    ApiCredentials(
      baseUrl: project.baseUrl,
      clientId: creds.clientId,
      clientSecret: creds.clientSecret,
    ),
    onAuthRejected: rejected.reject,
  );
  ref.onDispose(api.close);
  return api;
}

/// The status code of the last 401/403 this client hit, or null.
///
/// A rotated or write-mode secret fails *every* endpoint identically, so the
/// four tabs used to each render their own copy of the same error and keep
/// re-requesting a doomed endpoint at full poll rate. HomeShell turns this into
/// one fixable screen; replacing the body unmounts the branches, which is what
/// actually stops the timers.
///
/// keepAlive and never invalidated: [activeApiProvider] clears it whenever it
/// rebuilds, so the notifier instance the API holds stays the live one.
@Riverpod(keepAlive: true)
class CredentialsRejected extends _$CredentialsRejected {
  @override
  int? build() => null;

  void reject(int statusCode) => state = statusCode;

  void clear() => state = null;
}

@Riverpod(keepAlive: true)
class DateRangeSelection extends _$DateRangeSelection {
  @override
  SelectedDateRange build() => ref.watch(localStoreProvider).dateRange;

  Future<void> set(SelectedDateRange range) async {
    state = range;
    try {
      await ref.read(localStoreProvider).setDateRange(range);
    } on Object catch (e) {
      debugPrint('dateRange persist failed: $e');
    }
  }
}
