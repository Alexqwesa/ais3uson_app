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

String _$clientsOfWorkerHash() => r'8cc7f0d7fe8681d950ee9c5c3c00c74c6e0096c1';
typedef ClientsOfWorkerRef = ProviderRef<List<ClientProfile>>;

/// Provider of clients for a [Worker].
///
/// {@category Providers}
///
/// Copied from [ClientsOfWorker].
@ProviderFor(ClientsOfWorker)
const clientsOfWorkerProvider = ClientsOfWorkerFamily();

/// Provider of clients for a [Worker].
///
/// {@category Providers}
///
/// Copied from [ClientsOfWorker].
class ClientsOfWorkerFamily extends Family<List<ClientProfile>> {
  /// Provider of clients for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [ClientsOfWorker].
  const ClientsOfWorkerFamily();

  /// Provider of clients for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [ClientsOfWorker].
  ClientsOfWorkerProvider call(
    Worker wp,
  ) {
    return ClientsOfWorkerProvider(
      wp,
    );
  }

  @override
  ClientsOfWorkerProvider getProviderOverride(
    covariant ClientsOfWorkerProvider provider,
  ) {
    return call(
      provider.wp,
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
  String? get name => r'clientsOfWorkerProvider';
}

/// Provider of clients for a [Worker].
///
/// {@category Providers}
///
/// Copied from [ClientsOfWorker].
class ClientsOfWorkerProvider extends Provider<List<ClientProfile>> {
  /// Provider of clients for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [ClientsOfWorker].
  ClientsOfWorkerProvider(
    this.wp,
  ) : super.internal(
          (ref) => ClientsOfWorker(
            ref,
            wp,
          ),
          from: clientsOfWorkerProvider,
          name: r'clientsOfWorkerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clientsOfWorkerHash,
          dependencies: ClientsOfWorkerFamily._dependencies,
          allTransitiveDependencies:
              ClientsOfWorkerFamily._allTransitiveDependencies,
        );

  final Worker wp;

  @override
  bool operator ==(Object other) {
    return other is ClientsOfWorkerProvider && other.wp == wp;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wp.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$servicesOfWorkerHash() => r'8ada54238b63e4afc17f17b0032152f8836bf704';
typedef ServicesOfWorkerRef = ProviderRef<List<ServiceEntry>>;

/// Provider of services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [ServicesOfWorker].
@ProviderFor(ServicesOfWorker)
const servicesOfWorkerProvider = ServicesOfWorkerFamily();

/// Provider of services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [ServicesOfWorker].
class ServicesOfWorkerFamily extends Family<List<ServiceEntry>> {
  /// Provider of services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [ServicesOfWorker].
  const ServicesOfWorkerFamily();

  /// Provider of services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [ServicesOfWorker].
  ServicesOfWorkerProvider call(
    Worker wp,
  ) {
    return ServicesOfWorkerProvider(
      wp,
    );
  }

  @override
  ServicesOfWorkerProvider getProviderOverride(
    covariant ServicesOfWorkerProvider provider,
  ) {
    return call(
      provider.wp,
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
  String? get name => r'servicesOfWorkerProvider';
}

/// Provider of services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [ServicesOfWorker].
class ServicesOfWorkerProvider extends Provider<List<ServiceEntry>> {
  /// Provider of services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [ServicesOfWorker].
  ServicesOfWorkerProvider(
    this.wp,
  ) : super.internal(
          (ref) => ServicesOfWorker(
            ref,
            wp,
          ),
          from: servicesOfWorkerProvider,
          name: r'servicesOfWorkerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$servicesOfWorkerHash,
          dependencies: ServicesOfWorkerFamily._dependencies,
          allTransitiveDependencies:
              ServicesOfWorkerFamily._allTransitiveDependencies,
        );

  final Worker wp;

  @override
  bool operator ==(Object other) {
    return other is ServicesOfWorkerProvider && other.wp == wp;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wp.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$planOfWorkerHash() => r'7651608e228095c0e3b6a9ec19a296e7ef2666d2';
typedef PlanOfWorkerRef = ProviderRef<List<ClientPlan>>;

/// Provider of planned services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [PlanOfWorker].
@ProviderFor(PlanOfWorker)
const planOfWorkerProvider = PlanOfWorkerFamily();

/// Provider of planned services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [PlanOfWorker].
class PlanOfWorkerFamily extends Family<List<ClientPlan>> {
  /// Provider of planned services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [PlanOfWorker].
  const PlanOfWorkerFamily();

  /// Provider of planned services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [PlanOfWorker].
  PlanOfWorkerProvider call(
    Worker wp,
  ) {
    return PlanOfWorkerProvider(
      wp,
    );
  }

  @override
  PlanOfWorkerProvider getProviderOverride(
    covariant PlanOfWorkerProvider provider,
  ) {
    return call(
      provider.wp,
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
  String? get name => r'planOfWorkerProvider';
}

/// Provider of planned services for a [Worker].
///
/// {@category Providers}
///
/// Copied from [PlanOfWorker].
class PlanOfWorkerProvider extends Provider<List<ClientPlan>> {
  /// Provider of planned services for a [Worker].
  ///
  /// {@category Providers}
  ///
  /// Copied from [PlanOfWorker].
  PlanOfWorkerProvider(
    this.wp,
  ) : super.internal(
          (ref) => PlanOfWorker(
            ref,
            wp,
          ),
          from: planOfWorkerProvider,
          name: r'planOfWorkerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$planOfWorkerHash,
          dependencies: PlanOfWorkerFamily._dependencies,
          allTransitiveDependencies:
              PlanOfWorkerFamily._allTransitiveDependencies,
        );

  final Worker wp;

  @override
  bool operator ==(Object other) {
    return other is PlanOfWorkerProvider && other.wp == wp;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, wp.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$workerHash() => r'78aa8eb5e7f0670f9ed45be6efce7afaa76c94ba';

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
