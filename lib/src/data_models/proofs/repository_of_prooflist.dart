// ignore_for_file: unnecessary_import

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// Create [Proofs] for [ClientProfile] at date,
///
/// if date is null: ref.watch(archiveDate) ?? DateTime.now().
/// {@category Providers}
final proofAtDate =
    Provider.family<Proofs, Tuple2<DateTime?, ClientProfile>>((ref, tuple) {
  return ref.watch(_proofAtDate(Tuple2(
    (tuple.item1 ?? ref.watch(archiveDate) ?? DateTime.now()).dateOnly(),
    tuple.item2,
  )));
});

/// Helper for [proofAtDate] - it cache Proofs.
final _proofAtDate =
    Provider.family<Proofs, Tuple2<DateTime, ClientProfile>>((ref, tuple) {
  final date = tuple.item1;
  final client = tuple.item2;

  return Proofs(
    workerId: client.workerProfile.key.workerDepId,
    contractId: client.contractId,
    date: standardFormat.format(date),
    serviceId: null,
    client: client.workerProfile.clients
        .firstWhere((element) => element.contractId == client.contractId)
        .name,
    worker: client.workerProfile.name,
    ref: ref.container,
  );
});

/// Create [Proofs] for [ClientService] at date,
/// if date is null: ref.watch(archiveDate) ?? DateTime.now().
///
/// {@category Providers}
final servProofAtDate =
    Provider.family<Proofs, Tuple2<DateTime?, ClientService>>((ref, tuple) {
  return ref.watch(_servProofAtDate(Tuple2(
    (tuple.item1 ?? ref.watch(archiveDate) ?? DateTime.now()).dateOnly(),
    tuple.item2,
  )));
});

/// Helper for [servProofAtDate] - it cache Proofs.
final _servProofAtDate =
    Provider.family<Proofs, Tuple2<DateTime, ClientService>>((ref, tuple) {
  final date = tuple.item1;
  final service = tuple.item2;

  return Proofs(
    workerId: service.workerDepId,
    contractId: service.contractId,
    date: standardFormat.format(date),
    serviceId: service.servId,
    client: service.workerProfile.clients
        .firstWhere((element) => element.contractId == service.contractId)
        .name,
    worker: service.workerProfile.name,
    service: service.shortText,
    ref: ref.container,
  );
});

/// Store list of ProofEntry for [Proofs] (for [ClientService]).
///
/// {@category Providers}
final groupsOfProof = StateNotifierProvider.family<_GroupsOfProofState,
    List<ProofEntry>, Proofs>((ref, proofList) {
  proofList.crawler();

  return _GroupsOfProofState();
});

class _GroupsOfProofState extends StateNotifier<List<ProofEntry>> {
  _GroupsOfProofState() : super([]);

  void add(ProofEntry value) {
    state = [...state, value];
  }

  // Todo: rework it
  void forceUpdate() {
    state = [...state];
  }

  @override
  set state(List<ProofEntry> value) {
    super.state = value;
  }
}
