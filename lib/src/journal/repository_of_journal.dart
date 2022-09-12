import 'dart:async';

import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:synchronized/synchronized.dart';

/// Provider of [servicesOfJournal] for [Journal].
///
/// {@category Providers}
/// {@category Journal}
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

/// Repository of [ServiceOfJournal] for [Journal], it:
///
/// - post new service,
/// - delete service,
/// - read services from hive(async),
/// - call [Journal.archiveOldServices].
/// Based on [Journal.aData] it filter list by date, or accept all if null.
///
/// {@category Providers}
/// {@category Journal}
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
          // > read or read filter from hive
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
