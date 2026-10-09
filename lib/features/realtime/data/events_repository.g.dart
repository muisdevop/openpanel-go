// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(eventsRepository)
final eventsRepositoryProvider = EventsRepositoryProvider._();

final class EventsRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventsRepository?>,
          EventsRepository?,
          FutureOr<EventsRepository?>
        >
    with
        $FutureModifier<EventsRepository?>,
        $FutureProvider<EventsRepository?> {
  EventsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<EventsRepository?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EventsRepository?> create(Ref ref) {
    return eventsRepository(ref);
  }
}

String _$eventsRepositoryHash() => r'c032bbeb5728303abb6fb7bacca363bdfbd3d8ed';

/// Live feed filters.

@ProviderFor(RealtimeFilters)
final realtimeFiltersProvider = RealtimeFiltersProvider._();

/// Live feed filters.
final class RealtimeFiltersProvider
    extends $NotifierProvider<RealtimeFilters, EventFilters> {
  /// Live feed filters.
  RealtimeFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeFiltersHash();

  @$internal
  @override
  RealtimeFilters create() => RealtimeFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventFilters>(value),
    );
  }
}

String _$realtimeFiltersHash() => r'288d7ca0150fec5d3660bc66c84ef82fc27d0960';

/// Live feed filters.

abstract class _$RealtimeFilters extends $Notifier<EventFilters> {
  EventFilters build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EventFilters, EventFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventFilters, EventFilters>,
              EventFilters,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Only the event-name filter is server-side; this keeps country/device
/// changes from triggering a refetch.

@ProviderFor(realtimeEventName)
final realtimeEventNameProvider = RealtimeEventNameProvider._();

/// Only the event-name filter is server-side; this keeps country/device
/// changes from triggering a refetch.

final class RealtimeEventNameProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Only the event-name filter is server-side; this keeps country/device
  /// changes from triggering a refetch.
  RealtimeEventNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeEventNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeEventNameHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return realtimeEventName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$realtimeEventNameHash() => r'694cf682d767094b0efbefa667c75543e6679610';

/// Live feed. [poll] refreshes silently and keeps the list on screen.

@ProviderFor(RealtimeEvents)
final realtimeEventsProvider = RealtimeEventsProvider._();

/// Live feed. [poll] refreshes silently and keeps the list on screen.
final class RealtimeEventsProvider
    extends $AsyncNotifierProvider<RealtimeEvents, List<OpenPanelEvent>> {
  /// Live feed. [poll] refreshes silently and keeps the list on screen.
  RealtimeEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeEventsHash();

  @$internal
  @override
  RealtimeEvents create() => RealtimeEvents();
}

String _$realtimeEventsHash() => r'ac8fdbbea7bea5d3bbe5728fbadd9a403d6f9edb';

/// Live feed. [poll] refreshes silently and keeps the list on screen.

abstract class _$RealtimeEvents extends $AsyncNotifier<List<OpenPanelEvent>> {
  FutureOr<List<OpenPanelEvent>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<OpenPanelEvent>>, List<OpenPanelEvent>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<OpenPanelEvent>>,
                List<OpenPanelEvent>
              >,
              AsyncValue<List<OpenPanelEvent>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(liveVisitors)
final liveVisitorsProvider = LiveVisitorsProvider._();

final class LiveVisitorsProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  LiveVisitorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveVisitorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveVisitorsHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return liveVisitors(ref);
  }
}

String _$liveVisitorsHash() => r'6d6f476dede8fd787c34d18b54466f10436aada3';
