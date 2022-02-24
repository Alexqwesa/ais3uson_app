import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// This class is for showing archived services, it show read only data for date [aDate].
///
/// It is stubbed version of [Journal] class.
///
/// {@category Journal}
class JournalArchive extends Journal {
  late DateTime aDate;

  JournalArchive(WorkerProfile wp, this.aDate) : super(wp);

  @override
  Future<void> postInit() async {
    hive = await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');
    hive.values.forEach((element) {
      switch (element.state) {
        case ServiceState.added:
          throw StateError('wrong ServiceState');
        case ServiceState.finished:
          finished.add(element);
          break;
        case ServiceState.rejected:
          throw StateError('wrong ServiceState');
        case ServiceState.outDated:
          outDated.add(element);
          break;
        default:
          throw StateError('wrong ServiceState');
      }
    });
    await hive.close();
    notifyListeners();
  }

  /// This method of base class is stubbed.
  @override
  Future<void> archiveOldServices() async {
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

extension DaysSinceEpoch on DateTime {
  int get daysSinceEpoch {
    return (millisecondsSinceEpoch + timeZoneOffset.inMilliseconds) ~/
        (Duration.secondsPerDay * 1000);
  }
}
