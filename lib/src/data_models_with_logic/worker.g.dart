// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workerByApiHash() => r'db9aff819bfe87c6556c8a948b6a8662fa28845b';

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

typedef WorkerByApiRef = ProviderRef<Worker>;

/// See also [workerByApi].
@ProviderFor(workerByApi)
const workerByApiProvider = WorkerByApiFamily();

/// See also [workerByApi].
class WorkerByApiFamily extends Family<Worker> {
  /// See also [workerByApi].
  const WorkerByApiFamily();

  /// See also [workerByApi].
  WorkerByApiProvider call(
    String apiKey,
  ) {
    return WorkerByApiProvider(
      apiKey,
    );
  }

  @override
  WorkerByApiProvider getProviderOverride(
    covariant WorkerByApiProvider provider,
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
  String? get name => r'workerByApiProvider';
}

/// See also [workerByApi].
class WorkerByApiProvider extends Provider<Worker> {
  /// See also [workerByApi].
  WorkerByApiProvider(
    this.apiKey,
  ) : super.internal(
          (ref) => workerByApi(
            ref,
            apiKey,
          ),
          from: workerByApiProvider,
          name: r'workerByApiProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workerByApiHash,
          dependencies: WorkerByApiFamily._dependencies,
          allTransitiveDependencies:
              WorkerByApiFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is WorkerByApiProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$workerHash() => r'e74337301f0c5d4bde158775769af30fe9d5fa26';

abstract class _$Worker extends BuildlessNotifier<WorkerKey> {
  late final WorkerKey key;

  WorkerKey build(
    WorkerKey key,
  );
}

/// Extension of [Worker] with providers:
/// [] - provider of list of [ClientProfile].
///
/// {@category Data Models}
///
/// Copied from [Worker].
@ProviderFor(Worker)
const workerProvider = WorkerFamily();

/// Extension of [Worker] with providers:
/// [] - provider of list of [ClientProfile].
///
/// {@category Data Models}
///
/// Copied from [Worker].
class WorkerFamily extends Family<WorkerKey> {
  /// Extension of [Worker] with providers:
  /// [] - provider of list of [ClientProfile].
  ///
  /// {@category Data Models}
  ///
  /// Copied from [Worker].
  const WorkerFamily();

  /// Extension of [Worker] with providers:
  /// [] - provider of list of [ClientProfile].
  ///
  /// {@category Data Models}
  ///
  /// Copied from [Worker].
  WorkerProvider call(
    WorkerKey key,
  ) {
    return WorkerProvider(
      key,
    );
  }

  @override
  WorkerProvider getProviderOverride(
    covariant WorkerProvider provider,
  ) {
    return call(
      provider.key,
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
  String? get name => r'workerProvider';
}

/// Extension of [Worker] with providers:
/// [] - provider of list of [ClientProfile].
///
/// {@category Data Models}
///
/// Copied from [Worker].
class WorkerProvider extends NotifierProviderImpl<Worker, WorkerKey> {
  /// Extension of [Worker] with providers:
  /// [] - provider of list of [ClientProfile].
  ///
  /// {@category Data Models}
  ///
  /// Copied from [Worker].
  WorkerProvider(
    this.key,
  ) : super.internal(
          () => Worker()..key = key,
          from: workerProvider,
          name: r'workerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workerHash,
          dependencies: WorkerFamily._dependencies,
          allTransitiveDependencies: WorkerFamily._allTransitiveDependencies,
        );

  final WorkerKey key;

  @override
  bool operator ==(Object other) {
    return other is WorkerProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  WorkerKey runNotifierBuild(
    covariant Worker notifier,
  ) {
    return notifier.build(
      key,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
