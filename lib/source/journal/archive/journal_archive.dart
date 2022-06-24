import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';

/// This class is for showing archived services at date [archiveDate].
///
/// It is stubbed and read only version of [Journal] class.
/// If [archiveDate] is null - read all service from journal and journal_archive.
/// TODO: The member [all] - sorted by date(from recent to old).
///
/// {@category Journal}
class JournalArchive extends Journal {
  JournalArchive(WorkerProfile wp) : super(wp);

  @override
  DateTime? get aData => ref.read(archiveDate);

  @override
  String get journalHiveName => 'journal_archive_$apiKey';

  /// This method of base class is stubbed.
  @override
  Future<void> archiveOldServices() async {
    return; // stub
  }

  /// This method of base class is stubbed.
  @override
  Future<void> delete({ServiceOfJournal? serv, String? uuid}) async {
    return; // stub
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

  // /// This method of base class is stubbed.
  // @override
  // Future<ServiceState?> _commitDel(ServiceOfJournal serv) async {
  //   return null; // stub
  // }
  //
  // /// This method of base class is stubbed.
  // @override
  // Future<ServiceState?> _commitAdd(ServiceOfJournal serv,
  //     {String? body}) async {
  //   return null; // stub
  // }
  //
  // /// This method of base class is stubbed.
  // @override
  // Future<ServiceState?> _commitUrl(String urlAddress, {String? body}) async {
  //   return null; // stub
  // }
}

/// Journal with all archived dates.
///
/// {@category Journal}
class JournalArchiveAll extends JournalArchive {
  JournalArchiveAll(WorkerProfile wp) : super(wp);

  /// If aData null - load all values.
  @override
  DateTime? get aData => null;
}
