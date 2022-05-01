import 'dart:async';

import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:synchronized/synchronized.dart';

/// Provider of [Journal] for [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
final journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  // () async {
  //   await ref.watch(hiveJournalBox(wp.hiveName).future);
  // }();
  ref.watch(isArchive);

  return ref.watch(archiveDate) != null
      ? ref.watch(journalArchiveOfWorker(wp))
      : ref.watch(_journalOfWorker(wp));
});

/// Today + archived [ServiceOfJournal] of client.
final fullArchiveOfClient =
    Provider.family<List<ServiceOfJournal>, ClientProfile>((ref, client) {
  return [
    ...ref.watch(_archiveOfClient(client)),
    ...ref
        .watch(_journalOfWorker(client.workerProfile))
        .all
        .where((element) => element.contractId == client.contractId),
  ];
});

final _archiveOfClient =
    Provider.family<List<ServiceOfJournal>, ClientProfile>((ref, client) {
  ref.watch(hiveJournalBox(client.workerProfile.hiveName));

  return (ref.watch(
            servicesOfJournal(
              ref.watch(journalArchiveAllOfWorker(client.workerProfile)),
            ),
          ) ??
          [])
      .where((element) => element.contractId == client.contractId)
      .toList();
});

/// This Journal, is the only one who can write to Hive.
final _journalOfWorker = Provider.family<Journal, WorkerProfile>((ref, wp) {
  return Journal(wp);
});

/// Depend on archiveDate, maybe autoDispose?
final journalArchiveOfWorker =
    Provider.family<Journal, WorkerProfile>((ref, wp) {
  ref.watch(archiveDate);

  return JournalArchive(wp);
});

/// Depend on archiveDate, maybe autoDispose?
final journalArchiveAllOfWorker =
    Provider.family<Journal, WorkerProfile>((ref, wp) {
  return JournalArchiveAll(wp);
});

/// Groups of [ServiceOfJournal] sorted by [ServiceState].
///
/// Depend on [servicesOfJournal], if not inited - return null.
final groupsOfJournal =
    Provider.family<Map<ServiceState, List<ServiceOfJournal>>?, Journal>(
  (ref, journal) {
    return groupBy<ServiceOfJournal, ServiceState>(
      ref.watch(servicesOfJournal(journal))!,
      (e) => e.state,
    );
  },
);

final servicesOfJournal = StateNotifierProvider.family<ServicesListState,
    List<ServiceOfJournal>?, Journal>((ref, journal) {
  ref.watch(archiveDate);
  final state = ServicesListState(journal);
  () async {
    await state.initAsync();
  }();

  return state;
});

final _lock = Lock();

/// This class store list of [ServiceOfJournal],
///
/// read them from hive(async), and [Journal.archiveOldServices].
/// Based on [Journal.aData] it filter list by date, or accept all if null.
class ServicesListState extends StateNotifier<List<ServiceOfJournal>?> {
  ServicesListState(this.journal) : super(null);

  final Journal journal;

  ProviderContainer get ref => journal.workerProfile.ref;

  Future<void> initAsync() async {
    //
    // > if first load
    //
    await _lock.synchronized(() async {
      if (super.state == null) {
        // open hiveBox
        await ref.read(hiveJournalBox(journal.journalHiveName).future);
        super.state = [
          ...state,
          //
          // > read from hive and filter if needed
          //
          if (journal.aData == null)
            ...ref.read(hiveJournalBox(journal.journalHiveName)).value!.values
          else
            ...ref
                .read(hiveJournalBox(journal.journalHiveName))
                .value!
                .values
                .where((element) =>
                    element.provDate.daysSinceEpoch ==
                    journal.aData!.daysSinceEpoch),
        ];
        //
        // > archive old services
        //
        await journal.archiveOldServices();
      }
    });
  }

  Future<int> post(ServiceOfJournal s) async {
    state = [...state, s];
    await ref.read(hiveJournalBox(journal.journalHiveName).future);
    final hive = ref.read(hiveJournalBox(journal.journalHiveName)).value;

    return await hive?.add(s) ?? -1;
  }

  @override
  List<ServiceOfJournal> get state {
    return super.state ?? <ServiceOfJournal>[];
  }

  Future<void> delete(ServiceOfJournal s) async {
    state = state.whereNot((element) => element.uid == s.uid).toList(
          growable: false,
        );
    await ref.read(hiveJournalBox(journal.journalHiveName).future);
    final hive = ref.read(hiveJournalBox(journal.journalHiveName)).value;

    await hive?.delete(s.key);
  }
}
