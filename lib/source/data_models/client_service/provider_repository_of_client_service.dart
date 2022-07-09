import 'package:ais3uson_app/source/data_models/client_service/client_service.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/provider_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/providers/repository_of_journal.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// Depend on [servicesOfJournal].
/// {@category Providers}
final groupsOfJournal =
    Provider.family<Map<ServiceState, List<ServiceOfJournal>>, Journal>(
  (ref, journal) {
    return groupBy<ServiceOfJournal, ServiceState>(
      ref.watch(servicesOfJournal(journal))!,
      (e) => e.state,
    );
  },
);

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// Depend on [servicesOfJournal].
/// {@category Providers}
final groupsOfJournalAtDate = Provider.family<
    Map<ServiceState, List<ServiceOfJournal>>, Tuple2<Journal, DateTime?>>(
  (ref, tuple) {
    final journal = tuple.item1;
    final date = tuple.item2;

    return date == null // do date check or not
        ? groupBy<ServiceOfJournal, ServiceState>(
            ref.watch(servicesOfJournal(journal))!,
            (e) => e.state,
          )
        : groupBy<ServiceOfJournal, ServiceState>(
            ref
                .watch(servicesOfJournal(journal))!
                .where((e) => e.provDate.dateOnly() == date),
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
    final groups = ref.watch(groupsOfJournalAtDate(Tuple2(
      ref.watch(journalOfWorkerAtDate(
        Tuple2(clientService.workerProfile, clientService.date),
      )),
      clientService.date,
    )));

    return groups.map(
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
final doneStaleErrorOf =
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

/// Provider helper for [ClientService].
///
/// {@category Providers}
final addedOfService = Provider.family<int, ClientService>((ref, cs) {
  return ref.watch(groupsOfService(cs))?[ServiceState.added]?.length ?? 0;
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final doneOfService = Provider.family<int, ClientService>((ref, cs) {
  return (ref.watch(groupsOfService(cs))?[ServiceState.finished]?.length ?? 0) +
      (ref.watch(groupsOfService(cs))?[ServiceState.outDated]?.length ?? 0);
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final allOfService = Provider.family<int, ClientService>((ref, cs) {
  return ref.watch(groupsOfService(cs))?.length ?? 0;
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final leftOfService = Provider.family<int, ClientService>((ref, cs) {
  return cs.plan -
      cs.filled -
      // analyzer bug?
      // ignore:  unnecessary_cast
      (ref.watch(doneOfService(cs)) as int) -
      (ref.watch(addedOfService(cs)));
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final deleteAllowedOfService = Provider.family<bool, ClientService>((ref, cs) {
  return ref.watch(allOfService(cs)) > 0 && ref.watch(isTodayOfService(cs));
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final addAllowedOfService = Provider.family<bool, ClientService>((ref, cs) {
  return ref.watch(leftOfService(cs)) > 0 && ref.watch(isTodayOfService(cs));
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final isTodayOfService = Provider.family<bool, ClientService>((ref, cs) {
  return !(cs.date != null &&
      (ref.watch(isArchive) && (cs.date != ref.watch(archiveDate)) ||
          (!ref.watch(isArchive) && cs.date != DateTimeExtensions.today())));
});
