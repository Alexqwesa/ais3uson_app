import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';

/// This class is for showing archived services at date [aDate].
///
/// It is stubbed and read only version of [Journal] class.
/// If [aDate] is null - read all service from journal and journal_archive.
/// TODO: The member [all] - sorted by date(from recent to old).
///
/// {@category Journal}
class JournalArchive extends Journal {
  JournalArchive(WorkerProfile wp, this.aDate) : super(wp);

  /// At what date is journal, null - load all values.
  final DateTime? aDate;

  @override
  String get journalHiveName => 'journal_archive_$apiKey';

  // List<ServiceOfJournal> get added => aDate == null ? super.added:
  // super.added.where;


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

  /// This method of base class is stubbed.
  @override
  Future<ServiceState?> commitDel(ServiceOfJournal serv) async {
    return null; // stub
  }

  /// This method of base class is stubbed.
  @override
  Future<ServiceState?> commitAdd(ServiceOfJournal serv, {String? body}) async {
    return null; // stub
  }

  /// This method of base class is stubbed.
  @override
  Future<ServiceState?> commitUrl(String urlAddress, {String? body}) async {
    return null; // stub
  }
}

/// Get millisecondsSinceEpoch and round down to days.
///
/// {@category Universal_helpers}
extension DaysSinceEpoch on DateTime {
  int get daysSinceEpoch {
    return (millisecondsSinceEpoch + timeZoneOffset.inMilliseconds) ~/
        (Duration.secondsPerDay * 1000);
  }
}
