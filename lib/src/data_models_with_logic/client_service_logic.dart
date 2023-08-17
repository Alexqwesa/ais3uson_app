import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// Model for [ServiceCard] and other widget.
///
/// This is mostly a view model for data from:
/// - [Journal],
///
/// {@category Data Models}
extension ClientServiceLogic on ClientService {
  Ref get ref => workerProfile.ref;

  // Provider<Journal> get journalOf => workerProfile.journalOf;

  Journal get _journal => ref.read(workerProfile.journalOf);

  //
  // > proof managing
  //
  Provider<(List<Proof>, ProofList)> get proofsOf => serviceProofAtDate(this);

  ProofList get proofs {
    final (_, controller) = ref.read(serviceProofAtDate(this));

    return controller;
  }

  void addProof() {
    proofs.addProof();
  }

  /// Add [ServiceOfJournal].
  Future<void> add() async {
    if (ref.read(addAllowedOf)) {
      await _journal.post(
        autoServiceOfJournal(
          servId: planned.servId,
          contractId: planned.contractId,
          workerId: workerDepId,
        ),
      );
    } else {
      showErrorNotification(tr().serviceIsFull);
    }
  }

  /// Delete [ServiceOfJournal].
  Future<void> delete() async {
    if (ref.read(deleteAllowedOf)) {
      await _journal.delete(
        uuid: _journal.getUuidOfLastService(
          servId: planned.servId,
          contractId: planned.contractId,
        ),
      );
    }
  }

  Provider<bool> get deleteAllowedOf => _deleteAllowedOfService(this);

  Provider<bool> get addAllowedOf => _addAllowedOfService(this);

  Provider<List<int>> get fullStateOf => _fullState(this);
}

/// Provider helper for [ClientService].
///
/// {@category Providers}
final _deleteAllowedOfService = Provider.family<bool, ClientService>((ref, cs) {
  return ref.watch(_allOfService(cs)) > 0 && ref.watch(_isTodayOfService(cs));
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final _addAllowedOfService = Provider.family<bool, ClientService>((ref, cs) {
  return ref.watch(_leftOfService(cs)) > 0 && ref.watch(_isTodayOfService(cs));
});

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// Depend on [Journal.servicesOf].
/// {@category Providers}
final groupsOfJournal =
    Provider.family<Map<ServiceState, List<ServiceOfJournal>>, Journal>(
  (ref, journal) {
    return groupBy<ServiceOfJournal, ServiceState>(
      ref.watch(journal.servicesOf)!,
      (e) => e.state,
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
final _fullState =
    Provider.family<List<int>, ClientService>((ref, clientService) {
  final groups = ref.watch(_groupsOfService(clientService));

  return groups == null
      ? <int>[0, 0, 0]
      : List.unmodifiable(<int>[
          (groups[ServiceState.finished]?.length ?? 0) +
              (groups[ServiceState.outDated]?.length ?? 0),
          groups[ServiceState.added]?.length ?? 0,
          groups[ServiceState.rejected]?.length ?? 0,
        ]);
});

/// Provider of groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// Depend on [Journal.servicesOf].
/// {@category Providers}
final _groupsOfJournalAtDate = Provider.family<
    Map<ServiceState, List<ServiceOfJournal>>, Tuple2<Journal, DateTime?>>(
  (ref, tuple) {
    final journal = tuple.item1;
    final date = tuple.item2;
    final journalServices = ref.watch(journal.servicesOf);

    return date == null // do date check or not
        ? groupBy<ServiceOfJournal, ServiceState>(
            journalServices,
            (e) => e.state,
          )
        : groupBy<ServiceOfJournal, ServiceState>(
            journalServices.where((e) => e.provDate.dateOnly() == date),
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
final _groupsOfService =
    Provider.family<Map<ServiceState, List<ServiceOfJournal>>?, ClientService>(
  (ref, clientService) {
    final wp = clientService.workerProfile;
    final journal = clientService.date == null
        ? ref.watch(wp.journalAllOf)
        : ref.watch(wp.journalAtDateOf(clientService.date!));
    final groups = ref.watch(_groupsOfJournalAtDate(Tuple2(
      journal,
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

/// Provider helper for [ClientService].
///
/// {@category Providers}
final _addedOfService = Provider.family<int, ClientService>((ref, cs) {
  return ref.watch(_groupsOfService(cs))?[ServiceState.added]?.length ?? 0;
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final _doneOfService = Provider.family<int, ClientService>((ref, cs) {
  final serviceGroup = ref.watch(_groupsOfService(cs));

  return (serviceGroup?[ServiceState.finished]?.length ?? 0) +
      (serviceGroup?[ServiceState.outDated]?.length ?? 0);
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final _allOfService = Provider.family<int, ClientService>((ref, cs) {
  return ref.watch(_groupsOfService(cs))?.length ?? 0;
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final _leftOfService = Provider.family<int, ClientService>((ref, cs) {
  return cs.plan -
      cs.filled -
      // analyzer bug?
      // ignore:  unnecessary_cast
      (ref.watch(_doneOfService(cs)) as int) -
      (ref.watch(_addedOfService(cs)));
});

/// Provider helper for [ClientService].
///
/// {@category Providers}
final _isTodayOfService = Provider.family<bool, ClientService>((ref, cs) {
  final archive = ref.watch(isArchive);

  return !(cs.date != null &&
      (archive && (cs.date != ref.watch(archiveDate)) ||
          (!archive && cs.date != DateTimeExtensions.today())));
});
