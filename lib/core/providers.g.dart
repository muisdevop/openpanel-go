// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Opened in main() and injected via ProviderScope overrides.

@ProviderFor(localStore)
final localStoreProvider = LocalStoreProvider._();

/// Opened in main() and injected via ProviderScope overrides.

final class LocalStoreProvider
    extends $FunctionalProvider<LocalStore, LocalStore, LocalStore>
    with $Provider<LocalStore> {
  /// Opened in main() and injected via ProviderScope overrides.
  LocalStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStoreHash();

  @$internal
  @override
  $ProviderElement<LocalStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalStore create(Ref ref) {
    return localStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStore>(value),
    );
  }
}

String _$localStoreHash() => r'5d99a623797b1c2b8cf28acffcc9de5a1222e35e';

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          SecureStorageService,
          SecureStorageService,
          SecureStorageService
        >
    with $Provider<SecureStorageService> {
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<SecureStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SecureStorageService create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorageService>(value),
    );
  }
}

String _$secureStorageHash() => r'89f21a25a27c36c6b6f54930999ef4f46b858309';

/// All saved projects.

@ProviderFor(Projects)
final projectsProvider = ProjectsProvider._();

/// All saved projects.
final class ProjectsProvider
    extends $NotifierProvider<Projects, List<ProjectConfig>> {
  /// All saved projects.
  ProjectsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsHash();

  @$internal
  @override
  Projects create() => Projects();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ProjectConfig> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ProjectConfig>>(value),
    );
  }
}

String _$projectsHash() => r'98120e9cf1953b8948a3e60a642435f148da3628';

/// All saved projects.

abstract class _$Projects extends $Notifier<List<ProjectConfig>> {
  List<ProjectConfig> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ProjectConfig>, List<ProjectConfig>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ProjectConfig>, List<ProjectConfig>>,
              List<ProjectConfig>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ActiveProjectId)
final activeProjectIdProvider = ActiveProjectIdProvider._();

final class ActiveProjectIdProvider
    extends $NotifierProvider<ActiveProjectId, String?> {
  ActiveProjectIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeProjectIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeProjectIdHash();

  @$internal
  @override
  ActiveProjectId create() => ActiveProjectId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activeProjectIdHash() => r'd848ac6961eef206fbde3facea5249db59a02eca';

abstract class _$ActiveProjectId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(activeProject)
final activeProjectProvider = ActiveProjectProvider._();

final class ActiveProjectProvider
    extends $FunctionalProvider<ProjectConfig?, ProjectConfig?, ProjectConfig?>
    with $Provider<ProjectConfig?> {
  ActiveProjectProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeProjectProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeProjectHash();

  @$internal
  @override
  $ProviderElement<ProjectConfig?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProjectConfig? create(Ref ref) {
    return activeProject(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectConfig? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectConfig?>(value),
    );
  }
}

String _$activeProjectHash() => r'381737d3eca6e1e377bb1a2b7418a062c68ebec5';

/// The API client for the active project, rebuilt whenever it changes.
///
/// Null means "no project selected". A selected project whose secret is
/// missing is an [ApiException.noCredentials] — not null, because every
/// consumer had to re-derive that distinction and the screens that didn't
/// showed an empty feed instead of a fixable error.

@ProviderFor(activeApi)
final activeApiProvider = ActiveApiProvider._();

/// The API client for the active project, rebuilt whenever it changes.
///
/// Null means "no project selected". A selected project whose secret is
/// missing is an [ApiException.noCredentials] — not null, because every
/// consumer had to re-derive that distinction and the screens that didn't
/// showed an empty feed instead of a fixable error.

final class ActiveApiProvider
    extends
        $FunctionalProvider<
          AsyncValue<OpenPanelApi?>,
          OpenPanelApi?,
          FutureOr<OpenPanelApi?>
        >
    with $FutureModifier<OpenPanelApi?>, $FutureProvider<OpenPanelApi?> {
  /// The API client for the active project, rebuilt whenever it changes.
  ///
  /// Null means "no project selected". A selected project whose secret is
  /// missing is an [ApiException.noCredentials] — not null, because every
  /// consumer had to re-derive that distinction and the screens that didn't
  /// showed an empty feed instead of a fixable error.
  ActiveApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeApiHash();

  @$internal
  @override
  $FutureProviderElement<OpenPanelApi?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OpenPanelApi?> create(Ref ref) {
    return activeApi(ref);
  }
}

String _$activeApiHash() => r'b742867316ce2cb01958d8299246e3f7901f36cb';

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

@ProviderFor(CredentialsRejected)
final credentialsRejectedProvider = CredentialsRejectedProvider._();

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
final class CredentialsRejectedProvider
    extends $NotifierProvider<CredentialsRejected, int?> {
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
  CredentialsRejectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'credentialsRejectedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$credentialsRejectedHash();

  @$internal
  @override
  CredentialsRejected create() => CredentialsRejected();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$credentialsRejectedHash() =>
    r'5f4127d91ec578682486c24c21100c2b6fb377c8';

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

abstract class _$CredentialsRejected extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DateRangeSelection)
final dateRangeSelectionProvider = DateRangeSelectionProvider._();

final class DateRangeSelectionProvider
    extends $NotifierProvider<DateRangeSelection, SelectedDateRange> {
  DateRangeSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateRangeSelectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateRangeSelectionHash();

  @$internal
  @override
  DateRangeSelection create() => DateRangeSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectedDateRange value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectedDateRange>(value),
    );
  }
}

String _$dateRangeSelectionHash() =>
    r'6fe72504be04bbcb3ee023c6eb53ba98d41ff263';

abstract class _$DateRangeSelection extends $Notifier<SelectedDateRange> {
  SelectedDateRange build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SelectedDateRange, SelectedDateRange>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SelectedDateRange, SelectedDateRange>,
              SelectedDateRange,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
