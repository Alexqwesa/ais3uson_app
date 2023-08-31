import 'dart:io';

import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proof_list.g.dart';

/// Create [ProofList] for [Client] at date,
///
/// if date is null: ref.watch(archiveDate) ?? DateTime.now().
/// {@category Providers}
final groupProofAtDate =
    Provider.family<(List<Proof>, ProofList), (DateTime?, Client)>(
  (ref, (DateTime? date, Client client) pair) {
    final (date, client) = pair;

    final proofList = ProofListProvider(
      workerId: client.worker.key.workerDepId,
      contractId: client.contractId,
      date: standardFormat.format(
        (date ?? ref.watch(appStateProvider).atDate ?? DateTime.now())
            .dateOnly(),
      ),
      serviceId: null,
      client: client.name,
      worker: client.worker.name,
    );

    return (ref.watch(proofList), ref.watch(proofList.notifier));
  },
);

/// Create [ProofList] for [ClientService] at date,
/// if date is null: ref.watch([appStateProvider]) ?? DateTime.now().
///
/// {@category Providers}
final serviceProofAtDate =
    Provider.family<(List<Proof>, ProofList), ClientService>(
  (ref, service) {
    final worker = ref.watch(workerProvider(service.apiKey));
    final proofList = proofListProvider(
      workerId: worker.key.workerDepId,
      contractId: service.contractId,
      date: standardFormat.format(
        (service.date ?? ref.watch(appStateProvider).atDate ?? DateTime.now())
            .dateOnly(),
      ),
      serviceId: service.servId,
      client: worker.clients
          .firstWhere(
            (element) => element.contractId == service.contractId,
            orElse: () => ref.read(stubClientProvider),
          )
          .name,
      worker: worker.key.name,
      // todo: should be apiKey
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
    loadProofsFromFS();

    return [];
  }

  @override
  void invalidateSelf() {
    ref.invalidateSelf();
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
