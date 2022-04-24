import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/proof_list.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Create ProofList for [ClientService].
///
/// {@category Providers}
final proofsOfServices =
    Provider.family<ProofList, ClientService>((ref, service) {
  return ProofList(
    service.workerDepId,
    service.contractId,
    standardFormat.format(DateTime.now()),
    service.servId,
    client: service.journal.workerProfile.clients
        .firstWhere((element) => element.contractId == service.contractId)
        .name,
    worker: service.journal.workerProfile.name,
    service: service.shortText,
  );
});

/// Create ProofList for [ClientService].
///
/// {@category Providers}
final groupsOfService =
    Provider.family<Map<ServiceState, List<ServiceOfJournal>>?, ClientService>(
  (ref, clientService) {
    final groups = ref.watch(groupsOfJournal(clientService.journal));

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

/// Create ProofList for [ClientService].
///
/// {@category Providers}
final listDoneProgressErrorOfService =
    Provider.family<List<int>, ClientService>((ref, clientService) {
  final groups = ref.watch(groupsOfService(clientService));

  return groups == null
      ? <int>[0, 0, 0]
      : List.unmodifiable(<int>[
          groups[ServiceState.finished]?.length ??
              0 + (groups[ServiceState.outDated]?.length ?? 0),
          groups[ServiceState.added]?.length ?? 0,
          groups[ServiceState.rejected]?.length ?? 0,
        ]);
});
