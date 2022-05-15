import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// Create [ProofList] for [ClientService] at date,
/// if date is null: ref.watch(archiveDate) ?? DateTime.now().
///
/// {@category Providers}
final proofsAtDate =
    Provider.family<ProofList, Tuple2<DateTime?, ClientService>>((ref, tuple) {
  return ref.watch(_proofsAtDate(Tuple2(
    (tuple.item1 ?? ref.watch(archiveDate) ?? DateTime.now()).dateOnly(),
    tuple.item2,
  )));
});

/// Helper for [proofsAtDate] - it cache ProofList.
final _proofsAtDate =
    Provider.family<ProofList, Tuple2<DateTime, ClientService>>((ref, tuple) {
  final date = tuple.item1;
  final service = tuple.item2;

  return ProofList(
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

/// Store list of ProofGroup for [ProofList] (for [ClientService]).
///
/// {@category Providers}
final groupsOfProof = StateNotifierProvider.family<_GroupsOfProofState,
    List<ProofGroup>, ProofList>((ref, proofList) {
  proofList.crawler();

  return _GroupsOfProofState();
});

class _GroupsOfProofState extends StateNotifier<List<ProofGroup>> {
  _GroupsOfProofState() : super([]);

  void add(ProofGroup value) {
    state = [...state, value];
  }

  @override
  set state(List<ProofGroup> value) {
    super.state = value;
  }
}
