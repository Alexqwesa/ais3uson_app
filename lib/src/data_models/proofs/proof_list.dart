import 'dart:io';

import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proof_list.g.dart';

/// Create [ProofList] for [ClientProfile] at date,
///
/// if date is null: ref.watch(archiveDate) ?? DateTime.now().
/// {@category Providers}
final groupProofAtDate =
    Provider.family<(List<Proof>, ProofList), (DateTime?, ClientProfile)>(
  (ref, (DateTime? date, ClientProfile client) pair) {
    final (date, client) = pair;

    final proofList = ProofListProvider(
      workerId: client.workerProfile.key.workerDepId,
      contractId: client.contractId,
      date: standardFormat.format(
        (date ?? ref.watch(archiveDate) ?? DateTime.now()).dateOnly(),
      ),
      serviceId: null,
      client: client.name,
      worker: client.workerProfile.name,
    );

    return (ref.watch(proofList), ref.watch(proofList.notifier));
  },
);

/// Create [ProofList] for [ClientService] at date,
/// if date is null: ref.watch(archiveDate) ?? DateTime.now().
///
/// {@category Providers}
final serviceProofAtDate =
    Provider.family<(List<Proof>, ProofList), ClientService>(
  (ref, service) {
    final proofList = proofListProvider(
      workerId: service.workerDepId,
      contractId: service.contractId,
      date: standardFormat.format(
        (service.date ?? ref.watch(archiveDate) ?? DateTime.now()).dateOnly(),
      ),
      serviceId: service.servId,
      client: ref
          .watch(service.workerProfile.clientsOf)
          .firstWhere(
            (element) => element.contractId == service.contractId,
            orElse: () => ref.read(stubClientProvider),
          )
          .name,
      worker: service.workerProfile.name,
      service: service.shortText,
    );

    return (ref.watch(proofList), ref.watch(proofList.notifier));
  },
);

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
@Riverpod(keepAlive: true)
class ProofList extends _$ProofList with ProofListOf {
  @override
  List<Proof> get proofs => state;

  @override
  List<Proof> build({
    required int workerId,
    required int contractId,
    required String date,
    required int? serviceId,
    String worker = '',
    String client = '',
    String service = '',
  }) {
    workerId_ = workerId;
    contractId_ = contractId;
    date_ = date;
    serviceId_ = serviceId;
    worker_ = worker;
    client_ = client;
    service_ = service;
    loadProofsFromFS();

    return [];
  }

  void add(Proof value) {
    state = [...state, value];
  }

  // Todo: rework it
  @override
  void forceUpdate() {
    state = [...state];
  }

  @override
  set state(List<Proof> value) {
    super.state = value;
  }

  @override
  void addProof() {
    state = [...state, Proof(this, name: (proofs.length).toString())];
  }

  /// Add new proof without notifying anyone.
  void addProofSilently() {
    state.add(Proof(this, name: (proofs.length).toString()));
  }

  @override
  void addProofFromFiles(
    File? beforeImg,
    File? beforeAudio,
    File? afterImg,
    File? afterAudio,
  ) {
    state = [
      ...state,
      // + new proof
      Proof(
        this,
        before: ProofEntry(
          image: beforeImg == null ? null : Image.file(beforeImg),
          audio: beforeAudio?.path,
        ),
        after: ProofEntry(
          image: afterImg == null ? null : Image.file(afterImg),
          audio: afterAudio?.path,
        ),
      ),
    ];
  }
}
