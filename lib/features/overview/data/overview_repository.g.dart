// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(overviewRepository)
final overviewRepositoryProvider = OverviewRepositoryProvider._();

final class OverviewRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<OverviewRepository?>,
          OverviewRepository?,
          FutureOr<OverviewRepository?>
        >
    with
        $FutureModifier<OverviewRepository?>,
        $FutureProvider<OverviewRepository?> {
  OverviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<OverviewRepository?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OverviewRepository?> create(Ref ref) {
    return overviewRepository(ref);
  }
}

String _$overviewRepositoryHash() =>
    r'8a03b3925665af4edbaf8ec84ea1afb12c5d1c8e';

@ProviderFor(overviewMetrics)
final overviewMetricsProvider = OverviewMetricsProvider._();

final class OverviewMetricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<OverviewMetrics?>,
          OverviewMetrics?,
          FutureOr<OverviewMetrics?>
        >
    with $FutureModifier<OverviewMetrics?>, $FutureProvider<OverviewMetrics?> {
  OverviewMetricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewMetricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewMetricsHash();

  @$internal
  @override
  $FutureProviderElement<OverviewMetrics?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OverviewMetrics?> create(Ref ref) {
    return overviewMetrics(ref);
  }
}

String _$overviewMetricsHash() => r'0bae2fc9f460fe595452bbd52d4d519d9ee8ac75';

@ProviderFor(visitorsChart)
final visitorsChartProvider = VisitorsChartProvider._();

final class VisitorsChartProvider
    extends
        $FunctionalProvider<
          AsyncValue<VisitorsChart?>,
          VisitorsChart?,
          FutureOr<VisitorsChart?>
        >
    with $FutureModifier<VisitorsChart?>, $FutureProvider<VisitorsChart?> {
  VisitorsChartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visitorsChartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visitorsChartHash();

  @$internal
  @override
  $FutureProviderElement<VisitorsChart?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VisitorsChart?> create(Ref ref) {
    return visitorsChart(ref);
  }
}

String _$visitorsChartHash() => r'ef530ae8ef2451c37747c7ca45caf85215e2bd6a';
