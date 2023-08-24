// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_hive_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hiveRepositoryHash() => r'f9716ead9a73f2ba31f313eeae17029011c5defc';

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

abstract class _$HiveRepository
    extends BuildlessNotifier<List<ServiceOfJournal>> {
  late final String apiKey;

  List<ServiceOfJournal> build(
    String apiKey,
  );
}

/// This class load/save List of [ServiceOfJournal] for [Journal].
///
/// It also:
///
/// - post new service,
/// - delete service,
/// - read services from hive(async) but provide sync values,
/// - and export it into json format.
///
/// {@category Providers}
/// {@category Journal}
///
/// Copied from [HiveRepository].
@ProviderFor(HiveRepository)
const hiveRepositoryProvider = HiveRepositoryFamily();

/// This class load/save List of [ServiceOfJournal] for [Journal].
///
/// It also:
///
/// - post new service,
/// - delete service,
/// - read services from hive(async) but provide sync values,
/// - and export it into json format.
///
/// {@category Providers}
/// {@category Journal}
///
/// Copied from [HiveRepository].
class HiveRepositoryFamily extends Family<List<ServiceOfJournal>> {
  /// This class load/save List of [ServiceOfJournal] for [Journal].
  ///
  /// It also:
  ///
  /// - post new service,
  /// - delete service,
  /// - read services from hive(async) but provide sync values,
  /// - and export it into json format.
  ///
  /// {@category Providers}
  /// {@category Journal}
  ///
  /// Copied from [HiveRepository].
  const HiveRepositoryFamily();

  /// This class load/save List of [ServiceOfJournal] for [Journal].
  ///
  /// It also:
  ///
  /// - post new service,
  /// - delete service,
  /// - read services from hive(async) but provide sync values,
  /// - and export it into json format.
  ///
  /// {@category Providers}
  /// {@category Journal}
  ///
  /// Copied from [HiveRepository].
  HiveRepositoryProvider call(
    String apiKey,
  ) {
    return HiveRepositoryProvider(
      apiKey,
    );
  }

  @override
  HiveRepositoryProvider getProviderOverride(
    covariant HiveRepositoryProvider provider,
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
  String? get name => r'hiveRepositoryProvider';
}

/// This class load/save List of [ServiceOfJournal] for [Journal].
///
/// It also:
///
/// - post new service,
/// - delete service,
/// - read services from hive(async) but provide sync values,
/// - and export it into json format.
///
/// {@category Providers}
/// {@category Journal}
///
/// Copied from [HiveRepository].
class HiveRepositoryProvider
    extends NotifierProviderImpl<HiveRepository, List<ServiceOfJournal>> {
  /// This class load/save List of [ServiceOfJournal] for [Journal].
  ///
  /// It also:
  ///
  /// - post new service,
  /// - delete service,
  /// - read services from hive(async) but provide sync values,
  /// - and export it into json format.
  ///
  /// {@category Providers}
  /// {@category Journal}
  ///
  /// Copied from [HiveRepository].
  HiveRepositoryProvider(
    this.apiKey,
  ) : super.internal(
          () => HiveRepository()..apiKey = apiKey,
          from: hiveRepositoryProvider,
          name: r'hiveRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hiveRepositoryHash,
          dependencies: HiveRepositoryFamily._dependencies,
          allTransitiveDependencies:
              HiveRepositoryFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is HiveRepositoryProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  List<ServiceOfJournal> runNotifierBuild(
    covariant HiveRepository notifier,
  ) {
    return notifier.build(
      apiKey,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
