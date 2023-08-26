import 'package:ais3uson_app/journal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// This class is for showing archived services at date [state].atDate.
///
/// It is stubbed and read only version of [Journal] class.
///
/// {@category Journal}
class JournalArchive extends Journal {
  JournalArchive(super.workerProfile, super.state);

  DateTime? get aDate => state.atDate;

  @override
  String get journalHiveName => 'journal_archive_$apiKey';

  @override
  // todo: rework it
  Box<ServiceOfJournal> get hive =>
      hiveRepository.openHive.requireValue; // only for test

  @override
  Ref get ref => workerProfile.ref;

  @override
  HiveRepository get hiveRepository => workerProfile.hiveRepository;

  @override
  JournalHttpInterface get httpInterface => workerProfile.http;

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
  Future<void> commitAll() async {
    return; // stub
  }
}
