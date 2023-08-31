// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clientsOfWorkerHash() => r'deba235e3ab340155d156f36e3b81ad10e511188';

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

typedef _ClientsOfWorkerRef = ProviderRef<List<Client>>;

/// Provider of clients for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_ClientsOfWorker].
@ProviderFor(_ClientsOfWorker)
const _clientsOfWorkerProvider = _ClientsOfWorkerFamily();

/// Provider of clients for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_ClientsOfWorker].
class _ClientsOfWorkerFamily extends Family<List<Client>> {
  /// Provider of clients for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_ClientsOfWorker].
  const _ClientsOfWorkerFamily();

  /// Provider of clients for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_ClientsOfWorker].
  _ClientsOfWorkerProvider call(
    String apiKey,
  ) {
    return _ClientsOfWorkerProvider(
      apiKey,
    );
  }

  @override
  _ClientsOfWorkerProvider getProviderOverride(
    covariant _ClientsOfWorkerProvider provider,
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
  String? get name => r'_clientsOfWorkerProvider';
}

/// Provider of clients for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_ClientsOfWorker].
class _ClientsOfWorkerProvider extends Provider<List<Client>> {
  /// Provider of clients for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_ClientsOfWorker].
  _ClientsOfWorkerProvider(
    this.apiKey,
  ) : super.internal(
          (ref) => _ClientsOfWorker(
            ref,
            apiKey,
          ),
          from: _clientsOfWorkerProvider,
          name: r'_clientsOfWorkerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clientsOfWorkerHash,
          dependencies: _ClientsOfWorkerFamily._dependencies,
          allTransitiveDependencies:
              _ClientsOfWorkerFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is _ClientsOfWorkerProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$servicesOfWorkerHash() => r'4fc419a4031276cd478a7fe5a1baadf5427ee783';
typedef _ServicesOfWorkerRef = ProviderRef<List<ServiceEntry>>;

/// Provider of services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_ServicesOfWorker].
@ProviderFor(_ServicesOfWorker)
const _servicesOfWorkerProvider = _ServicesOfWorkerFamily();

/// Provider of services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_ServicesOfWorker].
class _ServicesOfWorkerFamily extends Family<List<ServiceEntry>> {
  /// Provider of services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_ServicesOfWorker].
  const _ServicesOfWorkerFamily();

  /// Provider of services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_ServicesOfWorker].
  _ServicesOfWorkerProvider call(
    String apiKey,
  ) {
    return _ServicesOfWorkerProvider(
      apiKey,
    );
  }

  @override
  _ServicesOfWorkerProvider getProviderOverride(
    covariant _ServicesOfWorkerProvider provider,
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
  String? get name => r'_servicesOfWorkerProvider';
}

/// Provider of services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_ServicesOfWorker].
class _ServicesOfWorkerProvider extends Provider<List<ServiceEntry>> {
  /// Provider of services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_ServicesOfWorker].
  _ServicesOfWorkerProvider(
    this.apiKey,
  ) : super.internal(
          (ref) => _ServicesOfWorker(
            ref,
            apiKey,
          ),
          from: _servicesOfWorkerProvider,
          name: r'_servicesOfWorkerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$servicesOfWorkerHash,
          dependencies: _ServicesOfWorkerFamily._dependencies,
          allTransitiveDependencies:
              _ServicesOfWorkerFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is _ServicesOfWorkerProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$planOfWorkerHash() => r'9b26e7737db1fbb9c868029a5fc4fa1a8a8984d2';
typedef _PlanOfWorkerRef = ProviderRef<List<ClientPlan>>;

/// Provider of planned services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_PlanOfWorker].
@ProviderFor(_PlanOfWorker)
const _planOfWorkerProvider = _PlanOfWorkerFamily();

/// Provider of planned services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_PlanOfWorker].
class _PlanOfWorkerFamily extends Family<List<ClientPlan>> {
  /// Provider of planned services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_PlanOfWorker].
  const _PlanOfWorkerFamily();

  /// Provider of planned services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_PlanOfWorker].
  _PlanOfWorkerProvider call(
    String apiKey,
  ) {
    return _PlanOfWorkerProvider(
      apiKey,
    );
  }

  @override
  _PlanOfWorkerProvider getProviderOverride(
    covariant _PlanOfWorkerProvider provider,
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
  String? get name => r'_planOfWorkerProvider';
}

/// Provider of planned services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [_PlanOfWorker].
class _PlanOfWorkerProvider extends Provider<List<ClientPlan>> {
  /// Provider of planned services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [_PlanOfWorker].
  _PlanOfWorkerProvider(
    this.apiKey,
  ) : super.internal(
          (ref) => _PlanOfWorker(
            ref,
            apiKey,
          ),
          from: _planOfWorkerProvider,
          name: r'_planOfWorkerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$planOfWorkerHash,
          dependencies: _PlanOfWorkerFamily._dependencies,
          allTransitiveDependencies:
              _PlanOfWorkerFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is _PlanOfWorkerProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$workerHash() => r'3cb67a3ae1e078ba349d64b57aa1d633993464b0';

abstract class _$Worker extends BuildlessNotifier<WorkerState> {
  late final String apiKey;

  WorkerState build(
    String apiKey,
  );
}

/// Provider of [WorkerState] and functions to manage worker tasks:
///
/// {@category Data Models}
///
/// Copied from [Worker].
@ProviderFor(Worker)
const workerProvider = WorkerFamily();

/// Provider of [WorkerState] and functions to manage worker tasks:
///
/// {@category Data Models}
///
/// Copied from [Worker].
class WorkerFamily extends Family<WorkerState> {
  /// Provider of [WorkerState] and functions to manage worker tasks:
  ///
  /// {@category Data Models}
  ///
  /// Copied from [Worker].
  const WorkerFamily();

  /// Provider of [WorkerState] and functions to manage worker tasks:
  ///
  /// {@category Data Models}
  ///
  /// Copied from [Worker].
  WorkerProvider call(
    String apiKey,
  ) {
    return WorkerProvider(
      apiKey,
    );
  }

  @override
  WorkerProvider getProviderOverride(
    covariant WorkerProvider provider,
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
  String? get name => r'workerProvider';
}

/// Provider of [WorkerState] and functions to manage worker tasks:
///
/// {@category Data Models}
///
/// Copied from [Worker].
class WorkerProvider extends NotifierProviderImpl<Worker, WorkerState> {
  /// Provider of [WorkerState] and functions to manage worker tasks:
  ///
  /// {@category Data Models}
  ///
  /// Copied from [Worker].
  WorkerProvider(
    this.apiKey,
  ) : super.internal(
          () => Worker()..apiKey = apiKey,
          from: workerProvider,
          name: r'workerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workerHash,
          dependencies: WorkerFamily._dependencies,
          allTransitiveDependencies: WorkerFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is WorkerProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  WorkerState runNotifierBuild(
    covariant Worker notifier,
  ) {
    return notifier.build(
      apiKey,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
