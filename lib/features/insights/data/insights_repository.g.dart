// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(insightsRepository)
final insightsRepositoryProvider = InsightsRepositoryProvider._();

final class InsightsRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<InsightsRepository?>,
          InsightsRepository?,
          FutureOr<InsightsRepository?>
        >
    with
        $FutureModifier<InsightsRepository?>,
        $FutureProvider<InsightsRepository?> {
  InsightsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<InsightsRepository?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InsightsRepository?> create(Ref ref) {
    return insightsRepository(ref);
  }
}

String _$insightsRepositoryHash() =>
    r'53ecb6ea910ba26790053784d796a8b3b59c3a60';

@ProviderFor(breakdown)
final breakdownProvider = BreakdownFamily._();

final class BreakdownProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BreakdownItem>>,
          List<BreakdownItem>,
          FutureOr<List<BreakdownItem>>
        >
    with
        $FutureModifier<List<BreakdownItem>>,
        $FutureProvider<List<BreakdownItem>> {
  BreakdownProvider._({
    required BreakdownFamily super.from,
    required Breakdown super.argument,
  }) : super(
         retry: null,
         name: r'breakdownProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$breakdownHash();

  @override
  String toString() {
    return r'breakdownProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BreakdownItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BreakdownItem>> create(Ref ref) {
    final argument = this.argument as Breakdown;
    return breakdown(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BreakdownProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$breakdownHash() => r'489e90ac33d415fbd106b89d6889251210eff4ee';

final class BreakdownFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BreakdownItem>>, Breakdown> {
  BreakdownFamily._()
    : super(
        retry: null,
        name: r'breakdownProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BreakdownProvider call(Breakdown b) =>
      BreakdownProvider._(argument: b, from: this);

  @override
  String toString() => r'breakdownProvider';
}
