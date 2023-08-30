// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$proofListHash() => r'280dab1008adb74ae8e2d925c1e67f00a1a018a6';

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

abstract class _$ProofList extends BuildlessNotifier<List<Proof>> {
  late final int workerId;
  late final int contractId;
  late final String date;
  late final int? serviceId;
  late final String worker;
  late final String client;
  late final String service;

  List<Proof> build({
    required int workerId,
    required int contractId,
    required String date,
    required int? serviceId,
    String worker = '',
    String client = '',
    String service = '',
  });
}

/// Notifier that store and manage list of [ProofEntry].
///
/// It does:
/// - load proofs from filesystem with [loadProofsFromFS] function,
/// - it is a Notifier,
/// - add new proofs,
/// - ...
///
/// If serviceId == null, it create/collect proof for whole day.
///
/// {@category Inner API}
/// {@category Providers}
///
/// Copied from [ProofList].
@ProviderFor(ProofList)
const proofListProvider = ProofListFamily();

/// Notifier that store and manage list of [ProofEntry].
///
/// It does:
/// - load proofs from filesystem with [loadProofsFromFS] function,
/// - it is a Notifier,
/// - add new proofs,
/// - ...
///
/// If serviceId == null, it create/collect proof for whole day.
///
/// {@category Inner API}
/// {@category Providers}
///
/// Copied from [ProofList].
class ProofListFamily extends Family<List<Proof>> {
  /// Notifier that store and manage list of [ProofEntry].
  ///
  /// It does:
  /// - load proofs from filesystem with [loadProofsFromFS] function,
  /// - it is a Notifier,
  /// - add new proofs,
  /// - ...
  ///
  /// If serviceId == null, it create/collect proof for whole day.
  ///
  /// {@category Inner API}
  /// {@category Providers}
  ///
  /// Copied from [ProofList].
  const ProofListFamily();

  /// Notifier that store and manage list of [ProofEntry].
  ///
  /// It does:
  /// - load proofs from filesystem with [loadProofsFromFS] function,
  /// - it is a Notifier,
  /// - add new proofs,
  /// - ...
  ///
  /// If serviceId == null, it create/collect proof for whole day.
  ///
  /// {@category Inner API}
  /// {@category Providers}
  ///
  /// Copied from [ProofList].
  ProofListProvider call({
    required int workerId,
    required int contractId,
    required String date,
    required int? serviceId,
    String worker = '',
    String client = '',
    String service = '',
  }) {
    return ProofListProvider(
      workerId: workerId,
      contractId: contractId,
      date: date,
      serviceId: serviceId,
      worker: worker,
      client: client,
      service: service,
    );
  }

  @override
  ProofListProvider getProviderOverride(
    covariant ProofListProvider provider,
  ) {
    return call(
      workerId: provider.workerId,
      contractId: provider.contractId,
      date: provider.date,
      serviceId: provider.serviceId,
      worker: provider.worker,
      client: provider.client,
      service: provider.service,
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
  String? get name => r'proofListProvider';
}

/// Notifier that store and manage list of [ProofEntry].
///
/// It does:
/// - load proofs from filesystem with [loadProofsFromFS] function,
/// - it is a Notifier,
/// - add new proofs,
/// - ...
///
/// If serviceId == null, it create/collect proof for whole day.
///
/// {@category Inner API}
/// {@category Providers}
///
/// Copied from [ProofList].
class ProofListProvider extends NotifierProviderImpl<ProofList, List<Proof>> {
  /// Notifier that store and manage list of [ProofEntry].
  ///
  /// It does:
  /// - load proofs from filesystem with [loadProofsFromFS] function,
  /// - it is a Notifier,
  /// - add new proofs,
  /// - ...
  ///
  /// If serviceId == null, it create/collect proof for whole day.
  ///
  /// {@category Inner API}
  /// {@category Providers}
  ///
  /// Copied from [ProofList].
  ProofListProvider({
    required this.workerId,
    required this.contractId,
    required this.date,
    required this.serviceId,
    this.worker = '',
    this.client = '',
    this.service = '',
  }) : super.internal(
          () => ProofList()
            ..workerId = workerId
            ..contractId = contractId
            ..date = date
            ..serviceId = serviceId
            ..worker = worker
            ..client = client
            ..service = service,
          from: proofListProvider,
          name: r'proofListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$proofListHash,
          dependencies: ProofListFamily._dependencies,
          allTransitiveDependencies: ProofListFamily._allTransitiveDependencies,
        );

  final int workerId;
  final int contractId;
  final String date;
  final int? serviceId;
  final String worker;
  final String client;
  final String service;

  @override
  bool operator ==(Object other) {
    return other is ProofListProvider &&
        other.workerId == workerId &&
        other.contractId == contractId &&
        other.date == date &&
        other.serviceId == serviceId &&
        other.worker == worker &&
        other.client == client &&
        other.service == service;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workerId.hashCode);
    hash = _SystemHash.combine(hash, contractId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);
    hash = _SystemHash.combine(hash, worker.hashCode);
    hash = _SystemHash.combine(hash, client.hashCode);
    hash = _SystemHash.combine(hash, service.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  List<Proof> runNotifierBuild(
    covariant ProofList notifier,
  ) {
    return notifier.build(
      workerId: workerId,
      contractId: contractId,
      date: date,
      serviceId: serviceId,
      worker: worker,
      client: client,
      service: service,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
