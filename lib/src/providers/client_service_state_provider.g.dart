// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_service_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceStateHash() => r'ddf415feefd44a11703ddff8998929f7c90fc50a';

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

typedef ServiceStateRef = AutoDisposeProviderRef<ClientServiceState>;

/// Model for [ServiceCard] and other widget.
///
/// This is mostly a view model for data from:
/// - [Journal],
///
/// {@category Data Models}
///
/// Copied from [serviceState].
@ProviderFor(serviceState)
const serviceStateProvider = ServiceStateFamily();

/// Model for [ServiceCard] and other widget.
///
/// This is mostly a view model for data from:
/// - [Journal],
///
/// {@category Data Models}
///
/// Copied from [serviceState].
class ServiceStateFamily extends Family<ClientServiceState> {
  /// Model for [ServiceCard] and other widget.
  ///
  /// This is mostly a view model for data from:
  /// - [Journal],
  ///
  /// {@category Data Models}
  ///
  /// Copied from [serviceState].
  const ServiceStateFamily();

  /// Model for [ServiceCard] and other widget.
  ///
  /// This is mostly a view model for data from:
  /// - [Journal],
  ///
  /// {@category Data Models}
  ///
  /// Copied from [serviceState].
  ServiceStateProvider call(
    ClientService client,
  ) {
    return ServiceStateProvider(
      client,
    );
  }

  @override
  ServiceStateProvider getProviderOverride(
    covariant ServiceStateProvider provider,
  ) {
    return call(
      provider.client,
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
  String? get name => r'serviceStateProvider';
}

/// Model for [ServiceCard] and other widget.
///
/// This is mostly a view model for data from:
/// - [Journal],
///
/// {@category Data Models}
///
/// Copied from [serviceState].
class ServiceStateProvider extends AutoDisposeProvider<ClientServiceState> {
  /// Model for [ServiceCard] and other widget.
  ///
  /// This is mostly a view model for data from:
  /// - [Journal],
  ///
  /// {@category Data Models}
  ///
  /// Copied from [serviceState].
  ServiceStateProvider(
    this.client,
  ) : super.internal(
          (ref) => serviceState(
            ref,
            client,
          ),
          from: serviceStateProvider,
          name: r'serviceStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceStateHash,
          dependencies: ServiceStateFamily._dependencies,
          allTransitiveDependencies:
              ServiceStateFamily._allTransitiveDependencies,
        );

  final ClientService client;

  @override
  bool operator ==(Object other) {
    return other is ServiceStateProvider && other.client == client;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, client.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$jServicesOfClientHash() => r'aed9ed7da308ffbbbb2138067c2d5baf35ed4938';
typedef JServicesOfClientRef
    = ProviderRef<Map<ServiceState, List<ServiceOfJournal>>>;

/// Return [ServiceOfJournal] grouped by type for [ClientService].
///
/// Copied from [jServicesOfClient].
@ProviderFor(jServicesOfClient)
const jServicesOfClientProvider = JServicesOfClientFamily();

/// Return [ServiceOfJournal] grouped by type for [ClientService].
///
/// Copied from [jServicesOfClient].
class JServicesOfClientFamily
    extends Family<Map<ServiceState, List<ServiceOfJournal>>> {
  /// Return [ServiceOfJournal] grouped by type for [ClientService].
  ///
  /// Copied from [jServicesOfClient].
  const JServicesOfClientFamily();

  /// Return [ServiceOfJournal] grouped by type for [ClientService].
  ///
  /// Copied from [jServicesOfClient].
  JServicesOfClientProvider call(
    ClientService clientService,
  ) {
    return JServicesOfClientProvider(
      clientService,
    );
  }

  @override
  JServicesOfClientProvider getProviderOverride(
    covariant JServicesOfClientProvider provider,
  ) {
    return call(
      provider.clientService,
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
  String? get name => r'jServicesOfClientProvider';
}

/// Return [ServiceOfJournal] grouped by type for [ClientService].
///
/// Copied from [jServicesOfClient].
class JServicesOfClientProvider
    extends Provider<Map<ServiceState, List<ServiceOfJournal>>> {
  /// Return [ServiceOfJournal] grouped by type for [ClientService].
  ///
  /// Copied from [jServicesOfClient].
  JServicesOfClientProvider(
    this.clientService,
  ) : super.internal(
          (ref) => jServicesOfClient(
            ref,
            clientService,
          ),
          from: jServicesOfClientProvider,
          name: r'jServicesOfClientProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$jServicesOfClientHash,
          dependencies: JServicesOfClientFamily._dependencies,
          allTransitiveDependencies:
              JServicesOfClientFamily._allTransitiveDependencies,
        );

  final ClientService clientService;

  @override
  bool operator ==(Object other) {
    return other is JServicesOfClientProvider &&
        other.clientService == clientService;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clientService.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$servicesOfJournalHash() => r'e5588702f120354071a2f5ee7b41554d3696ea00';
typedef ServicesOfJournalRef
    = ProviderRef<Map<ServiceState, List<ServiceOfJournal>>>;

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// {@category Providers}
///
/// Copied from [servicesOfJournal].
@ProviderFor(servicesOfJournal)
const servicesOfJournalProvider = ServicesOfJournalFamily();

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// {@category Providers}
///
/// Copied from [servicesOfJournal].
class ServicesOfJournalFamily
    extends Family<Map<ServiceState, List<ServiceOfJournal>>> {
  /// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
  ///
  /// {@category Providers}
  ///
  /// Copied from [servicesOfJournal].
  const ServicesOfJournalFamily();

  /// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
  ///
  /// {@category Providers}
  ///
  /// Copied from [servicesOfJournal].
  ServicesOfJournalProvider call(
    Journal journal,
  ) {
    return ServicesOfJournalProvider(
      journal,
    );
  }

  @override
  ServicesOfJournalProvider getProviderOverride(
    covariant ServicesOfJournalProvider provider,
  ) {
    return call(
      provider.journal,
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
  String? get name => r'servicesOfJournalProvider';
}

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// {@category Providers}
///
/// Copied from [servicesOfJournal].
class ServicesOfJournalProvider
    extends Provider<Map<ServiceState, List<ServiceOfJournal>>> {
  /// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
  ///
  /// {@category Providers}
  ///
  /// Copied from [servicesOfJournal].
  ServicesOfJournalProvider(
    this.journal,
  ) : super.internal(
          (ref) => servicesOfJournal(
            ref,
            journal,
          ),
          from: servicesOfJournalProvider,
          name: r'servicesOfJournalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$servicesOfJournalHash,
          dependencies: ServicesOfJournalFamily._dependencies,
          allTransitiveDependencies:
              ServicesOfJournalFamily._allTransitiveDependencies,
        );

  final Journal journal;

  @override
  bool operator ==(Object other) {
    return other is ServicesOfJournalProvider && other.journal == journal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, journal.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
