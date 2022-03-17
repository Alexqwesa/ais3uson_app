import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// This class is for showing archived services, it show read only data for date [aDate].
///
/// It is stubbed version of [Journal] class.
///
/// {@category Journal}
class JournalArchive extends Journal {
  DateTime? aDate;

  @override
  List<ServiceOfJournal> all = [];
  List<ServiceOfJournal> notApproved = [];

  JournalArchive(WorkerProfile wp, this.aDate) : super(wp);

  /// Read services from hive at date [aDate] or all dates.
  ///
  /// If [aDate] is null - read all service from hive journal and journal_archive.
  /// The member [all] - sorted by date(from recent to old).
  @override
  Future<void> postInit() async {
    //
    // > read hive at date or all
    //
    hive = await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');
    late final Iterable<ServiceOfJournal> hiveValues;
    hiveValues = aDate == null
        ? [...hive.values, ...workerProfile.journal.all]
        : hive.values;
    finished = <ServiceOfJournal>[];
    outDated = <ServiceOfJournal>[];
    //
    // > sort
    //
    final groups = groupBy<ServiceOfJournal, ServiceState>(
      hiveValues.where((element) =>
      aDate == null ||
          (element.provDate.isAfter(aDate!) &&
              element.provDate.isBefore(aDate!.add(const Duration(days: 1))))),
          (e) => e.state,
    );
    // skip rejected services,
    // since today service also can be here create notApproved for added services
    notApproved = groups[ServiceState.added] ?? [];
    finished = groups[ServiceState.finished] ?? [];
    outDated = groups[ServiceState.outDated] ?? [];
    //
    // > sort by date from recent to old
    //
    if (aDate == null) {
      all = [...finished, ...outDated]
        ..sort((a, b) => a.provDate.compareTo(b.provDate));
      all = all.reversed.toList();
    }
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

extension DaysSinceEpoch on DateTime {
  int get daysSinceEpoch {
    return (millisecondsSinceEpoch + timeZoneOffset.inMilliseconds) ~/
        (Duration.secondsPerDay * 1000);
  }
}
