// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'days_with_services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$daysWithServicesHash() => r'fae220e7bc00a420ff2b4adb9225d4e121c86d11';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DaysWithServices extends BuildlessNotifier<Set<DateTime>> {
  late final String apiKey;

  Set<DateTime> build(
    String apiKey,
  );
}

/// Dates at which where exist archived services in [Worker].
/// Depend on [hiveDateTimeBox] .
///
/// {@category Providers}
///
/// Copied from [DaysWithServices].
@ProviderFor(DaysWithServices)
const daysWithServicesProvider = DaysWithServicesFamily();

/// Dates at which where exist archived services in [Worker].
/// Depend on [hiveDateTimeBox] .
///
/// {@category Providers}
///
/// Copied from [DaysWithServices].
class DaysWithServicesFamily extends Family<Set<DateTime>> {
  /// Dates at which where exist archived services in [Worker].
  /// Depend on [hiveDateTimeBox] .
  ///
  /// {@category Providers}
  ///
  /// Copied from [DaysWithServices].
  const DaysWithServicesFamily();

  /// Dates at which where exist archived services in [Worker].
  /// Depend on [hiveDateTimeBox] .
  ///
  /// {@category Providers}
  ///
  /// Copied from [DaysWithServices].
  DaysWithServicesProvider call(
    String apiKey,
  ) {
    return DaysWithServicesProvider(
      apiKey,
    );
  }

  @override
  DaysWithServicesProvider getProviderOverride(
    covariant DaysWithServicesProvider provider,
  ) {
    return call(
      provider.apiKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'daysWithServicesProvider';
}

/// Dates at which where exist archived services in [Worker].
/// Depend on [hiveDateTimeBox] .
///
/// {@category Providers}
///
/// Copied from [DaysWithServices].
class DaysWithServicesProvider
    extends NotifierProviderImpl<DaysWithServices, Set<DateTime>> {
  /// Dates at which where exist archived services in [Worker].
  /// Depend on [hiveDateTimeBox] .
  ///
  /// {@category Providers}
  ///
  /// Copied from [DaysWithServices].
  DaysWithServicesProvider(
    this.apiKey,
  ) : super.internal(
          () => DaysWithServices()..apiKey = apiKey,
          from: daysWithServicesProvider,
          name: r'daysWithServicesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$daysWithServicesHash,
          dependencies: DaysWithServicesFamily._dependencies,
          allTransitiveDependencies:
              DaysWithServicesFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is DaysWithServicesProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Set<DateTime> runNotifierBuild(
    covariant DaysWithServices notifier,
  ) {
    return notifier.build(
      apiKey,
    );
  }
}

String _$allDaysWithServicesHash() =>
    r'c56f0ba24552eb754667d25e10600e8e1ad879d9';

/// Dates at which there are exist archived services (aggregate from
/// [daysWithServicesProvider]) for each [Worker].
///
/// {@category Providers}
///
/// Copied from [AllDaysWithServices].
@ProviderFor(AllDaysWithServices)
final allDaysWithServicesProvider =
    NotifierProvider<AllDaysWithServices, Set<DateTime>>.internal(
  AllDaysWithServices.new,
  name: r'allDaysWithServicesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allDaysWithServicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllDaysWithServices = Notifier<Set<DateTime>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
