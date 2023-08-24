import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// This class is for showing archived services at date [archiveDate].
///
/// It is stubbed and read only version of [Journal] class.
/// If [archiveDate] is null - read all service from journal and journal_archive.
/// TODO: The member [all] - sorted by date(from recent to old).
///
/// {@category Journal}
class JournalArchive extends Journal {
  JournalArchive(super.workerProfile);

  @override
  DateTime? get aData => ref.read(archiveDate);

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
