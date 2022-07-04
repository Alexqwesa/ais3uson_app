import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/repository_of_journal.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// Depend on [servicesOfJournal], if not inited - return null.
/// {@category Providers}
final groupsOfJournal =
    Provider.family<Map<ServiceState, List<ServiceOfJournal>>?, Journal>(
  (ref, journal) {
    return groupBy<ServiceOfJournal, ServiceState>(
      ref.watch(servicesOfJournal(journal))!,
      (e) => e.state,
    );
  },
);

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState] and
/// filtered by [ClientService].
///
/// Based on provider [groupsOfJournal].
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

/// Provider of [ClientService] statistics:
///
/// List of integers:
/// - Done (finished+outDated),
/// - Progress (added),
/// - Error (rejected).
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
