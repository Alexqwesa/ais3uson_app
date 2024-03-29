import 'package:ais3uson_app/journal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// This class is for showing archived services at date [state].atDate.
///
/// It is stubbed and read only version of [Journal] class.
///
/// {@category Journal}
class JournalArchive extends Journal {
  JournalArchive({
    required super.ref,
    required super.apiKey,
    required super.state,
  });

  DateTime? get aDate => state.atDate;

  @override
  String get journalHiveName => 'journal_archive_$apiKey';

  @override
  // todo: rework it
  Box<ServiceOfJournal> get hive =>
      hiveRepository.openHive.requireValue; // only for test

  // @override
  // HiveRepository get hiveRepository => worker.hiveRepository;

  @override
  JournalHttpInterface get httpInterface => worker.http;

  // @override
  @override
  HiveRepositoryProvider get servicesOf => hiveRepositoryProvider(apiKey);

  /// This method of base class is stubbed.
  @override
  Future<void> archiveOldServices() async {
    return; // stub
  }

  /// This method of base class is stubbed.
  @override
  Future<bool> delete({ServiceOfJournal? serv, String? uuid}) async {
    return false; // stub
  }

  /// This method of base class is stubbed.
  @override
  Future<void> updateBasedOnNewPlanDate() async {
    return; // stub
  }

  /// This method of base class is stubbed.
  @override
  Future<bool> post(ServiceOfJournal se) async {
    return false; // stub
  }

  /// This method of base class is stubbed.
  @override
  Future<void> commitAll(
      [JournalHttpInterface? httpClient,
      List<ServiceOfJournal>? forSync]) async {
    return; // stub
  }
}
