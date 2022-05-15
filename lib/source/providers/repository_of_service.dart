import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// Create ProofList for [ClientService] at date,
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

/// Create groups of journal services for [ClientService].
///
/// {@category Providers}
final groupsOfService =
    Provider.family<Map<ServiceState, List<ServiceOfJournal>>?, ClientService>(
  (ref, clientService) {
    final groups = ref.watch(groupsOfJournal(ref.watch(
      journalOfWorker(clientService.workerProfile),
    )));

    return groups?.map(
      (key, value) => MapEntry(
        key,
        value
            .where((e) =>
                e.contractId == clientService.contractId &&
                e.servId == clientService.servId)
            .toList(growable: false),
      ),
    );
  },
);

/// listDoneProgressErrorOfService for [ClientService].
///
/// {@category Providers}
final listDoneProgressErrorOfService =
    Provider.family<List<int>, ClientService>((ref, clientService) {
  final groups = ref.watch(groupsOfService(clientService));

  return groups == null
      ? <int>[0, 0, 0]
      : List.unmodifiable(<int>[
          (groups[ServiceState.finished]?.length ?? 0) +
              (groups[ServiceState.outDated]?.length ?? 0),
          groups[ServiceState.added]?.length ?? 0,
          groups[ServiceState.rejected]?.length ?? 0,
        ]);
});
