import 'dart:async';
import 'dart:convert';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_hive_repository.g.dart';

/// This class load/save List of [ServiceOfJournal] for [Journal].
///
/// It also:
///
/// - post new service,
/// - delete service,
/// - read services from hive(async) but provide sync values,
/// - and export it into json format.
///
/// {@category Providers}
/// {@category Journal}
@Riverpod(keepAlive: true)
class HiveRepository extends _$HiveRepository {
  bool init = false;

  // final preinit = <ServiceOfJournal>[];

  // maybe also wait for [archiveOldServices]?
  Future<Box<ServiceOfJournal>> future() async {
    return await ref.watch(hiveJournalBox(journalHiveName).future);
  }

  String get journalHiveName => 'journal_$apiKey';

  String get archiveHiveName => 'journal_archive_$apiKey';

  AsyncValue<Box<ServiceOfJournal>> get openHive =>
      ref.watch(hiveJournalBox(journalHiveName));

  AsyncValue<Box<ServiceOfJournal>> get openArchiveHive =>
      ref.watch(hiveJournalBox(archiveHiveName));

  @override
  List<ServiceOfJournal> build(String apiKey) {
    return openHive.when(
      data: (hive) {
        //
        // > archive old services
        //
        final data = hive.values;
        Future(() => archiveOldServices(data));
        final toDay = DateTime.now().dateOnly();
        init = true;
        return [
          ...data.where((element) => element.provDate.dateOnly() == toDay),
          // ...preinit
        ];
      },
      error: (o, stack) {
        log.severe('Error loading Hive');
        return [];
      },
      loading: () => [], // stub?
    );
  }

  /// This function move old finished(and outDated) services to Hive box with name [archiveHiveName].
  ///
  /// There are two reason to archive services,
  /// first - we want active hiveBox small and fast on all devices,
  /// second - we want worker to only see today's services, and
  /// services which didn't committed yet(stale/rejected).
  ///
  /// Archive is only for committed services.
  /// Only hiveArchiveLimit number of services could be stored in archive,
  /// the oldest services will be deleted first.
  Future<void> archiveOldServices(
      Iterable<ServiceOfJournal> currentState) async {
    //
    // > open hive archive and add old services
    //
    openArchiveHive.whenData((hiveArchive) async {
      final toDay = DateTime.now().dateOnly();
      final forDelete = currentState
          .whereNot((element) => element.provDate.dateOnly() == toDay);
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
        final archiveLimit = ref.read(journalArchiveSizeProvider);
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
        await updateArchiveDatesCache();
      }
    });
  }

  Future<void> updateArchiveDatesCache() async {
    openArchiveHive.whenData((hiveArchive) {
      ref.read(daysWithServicesProvider(apiKey).notifier).state = hiveArchive
          .values
          .map((element) => element.provDate)
          .map((e) => e.dateOnly())
          .toSet();
    });
  }

  /// Return json String with [ServiceOfJournal] between dates [start] and [end]
  ///
  /// It gets values from both hive and hiveArchive.
  /// The [end] date is not included,
  ///  the dates [DateTime] should be rounded to zero time.
  Future<String> export(DateTime start, DateTime end) async {
    Iterable<ServiceOfJournal> curState = state;
    if (openHive.isLoading) {
      await ref.read(hiveJournalBox(journalHiveName).future);
      curState = openHive.requireValue.values;
    }

    await ref.read(hiveJournalBox(archiveHiveName).future);
    final hiveArchive = openArchiveHive.requireValue.values;

    return jsonEncode({
      'api_key': apiKey,
      'services': [
        ...curState
            .where((s) => s.provDate.isAfter(start) && s.provDate.isBefore(end))
            .map((e) => e.toJson()),
        ...hiveArchive
            .where((s) => s.provDate.isAfter(start) && s.provDate.isBefore(end))
            .map((e) => e.toJson()),
      ],
    });
  }

  Future<int> post(ServiceOfJournal s) async {
    if (!init) return -1;
    // await ref.read(hiveJournalBox(journalHiveName).future);

    state = [...state, s];

    return await openHive.value?.add(s) ?? -1;
  }

  Future<void> delete(ServiceOfJournal s) async {
    if (!init) return;

    openHive.whenData((hive) {
      state = state.whereNot((element) => element.uid == s.uid).toList();
      hive.delete(s.key);
    });
  }
}
