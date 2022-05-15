import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
