import 'dart:async';
import 'dart:convert';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/settings.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:synchronized/synchronized.dart';

/// This class load/save List of [ServiceOfJournal] of [Journal].
///
/// and export it into json format.
class JournalHiveRepository {
  JournalHiveRepository(this.workerProfile);

  final WorkerProfile workerProfile;

  late Box<ServiceOfJournal> hive; // only for test
  late final Box<ServiceOfJournal> hiveArchive; // todo: use provider

  ProviderContainer get ref => workerProfile.ref;

  String get journalHiveName => 'journal_$apiKey';

  String get apiKey => workerProfile.apiKey;

  Provider<List<ServiceOfJournal>> get servicesOf =>
      _listOfServices(ref.read(workerProfile.journalOf));

  Future<Box<ServiceOfJournal>> get openHive async {
    return Hive.openBox<ServiceOfJournal>(journalHiveName);
  }

  /// Return json String with [ServiceOfJournal] between dates [start] and [end]
  ///
  /// It gets values from both hive and hiveArchive.
  /// The [end] date is not included,
  ///  the dates [DateTime] should be rounded to zero time.
  Future<String> export(DateTime start, DateTime end) async {
    // await save();
    hive = await openHive;
    hiveArchive =
        await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');

    return jsonEncode({
      'api_key': workerProfile.apiKey,
      'services': [
        ...hive.values
            .where((s) => s.provDate.isAfter(start) && s.provDate.isBefore(end))
            .map((e) => e.toJson()),
        ...hiveArchive.values
            .where((s) => s.provDate.isAfter(start) && s.provDate.isBefore(end))
            .map((e) => e.toJson()),
      ],
    });
  }

  /// This function move old finished(and outDated) services to [hiveArchive].
  ///
  /// There are two reason to archive services,
  /// first - we want active hiveBox small and fast on all devices,
  /// second - we want worker to only see today's services, and
  /// services which didn't committed yet(stale/rejected).
  ///
  /// Archive is only for committed services.
  /// Only hiveArchiveLimit number of services could be stored in archive,
  /// the oldest services will be deleted first.
  Future<void> archiveOldServices({
    required List<ServiceOfJournal> forDelete,
  }) async {
    //
    // > open hive archive and add old services
    //
    await ref.read(hiveJournalBox('journal_archive_$apiKey').future);
    hiveArchive = ref.read(hiveJournalBox('journal_archive_$apiKey')).value!;
    final forArchive = forDelete.map((e) => e.copyWith());
    if (forArchive.isNotEmpty) {
      await hiveArchive.addAll(forArchive); // check duplicates error
      //
      // > keep only [archiveLimit] number of services, delete oldest and close
      //
      // todo: check if hiveArch always place new services last,
      //  in that case we can just use deleteAt()
      final archList = hiveArchive.values.toList()
        ..sort((a, b) => a.provDate.compareTo(b.provDate))
        ..reversed;
      final archiveLimit = ref.read(hiveArchiveSize);
      if (hiveArchive.length > archiveLimit) {
        //
        // > delete all services after archList[archiveLimit]
        //
        await hiveArchive.deleteAll(
          archList.slice(archiveLimit).map<dynamic>((e) => e.key),
        );
      }
      await hiveArchive.compact();
      //
      // > update datesInArchive
      //
      await updateDatesInArchiveOfProfile();
    }
  }

  Future<void> updateDatesInArchiveOfProfile() async {
    await ref.read(hiveJournalBox('journal_archive_$apiKey').future);
    final hiveArchive =
        ref.read(hiveJournalBox('journal_archive_$apiKey')).value!;

    await ref
        .read(controllerDatesInArchive(apiKey).notifier)
        .updateFrom(hiveArchive.values);
  }

  Future<void> delete(ServiceOfJournal service) async {
    await ref
        .read(_controllerOf(ref.read(workerProfile.journalOf)).notifier)
        .delete(service);
  }

  Future<void> post(ServiceOfJournal service) async {
    await ref
        .read(_controllerOf(ref.read(workerProfile.journalOf)).notifier)
        .post(service);
  }

  Future<void> initAsync() async {
    await ref
        .read(_controllerOf(ref.read(workerProfile.journalOf)).notifier)
        .initAsync();
  }
}

final _listOfServices =
    Provider.family<List<ServiceOfJournal>, Journal>((ref, journal) {
  return ref.watch(_controllerOf(journal)) ?? [];
});

/// Controller of List<[ServiceOfJournal]> for [Journal] class.
///
/// See [_ControllerOfJournal] for more information.
///
/// {@category Providers}
/// {@category Journal}
final _controllerOf = StateNotifierProvider.family<_ControllerOfJournal,
    List<ServiceOfJournal>?, Journal>((ref, journal) {
  ref.watch(archiveDate);
  final state = _ControllerOfJournal(journal);
  () async {
    await state.initAsync();
  }();

  return state;
});

final _hiveLockProvider = Provider((ref) => Lock());

/// Controller of List<[ServiceOfJournal]> for [Journal] class, it:
///
/// - post new service,
/// - delete service,
/// - read services from hive(async),
/// - call [Journal.archiveOldServices].
/// Based on [Journal.aData] it filter list by date, or accept all if null.
///
/// {@category Providers}
/// {@category Journal}
class _ControllerOfJournal extends StateNotifier<List<ServiceOfJournal>?> {
  _ControllerOfJournal(this.journal) : super(null);

  final Journal journal;

  ProviderContainer get ref => journal.workerProfile.ref;

  Future<void> initAsync() async {
    //
    // > if first load
    //
    await ref.read(_hiveLockProvider).synchronized(() async {
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
