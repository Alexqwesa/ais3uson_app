import 'dart:async';

import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/basic_providers.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:synchronized/synchronized.dart';

final servicesOfJournal = StateNotifierProvider.family<ServicesListState,
    List<ServiceOfJournal>?, Journal>((ref, journal) {
  ref.watch(archiveDate);
  final state = ServicesListState(journal);
  () async {
    await state.initAsync();
  }();

  return state;
});

final _lockProvider = Provider((ref) => Lock());

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
    await ref.read(_lockProvider).synchronized(() async {
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
