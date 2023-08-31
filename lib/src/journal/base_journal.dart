import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';

/// Base class for [Journal] classes.
abstract class BaseJournal {
  BaseJournal({required this.apiKey});

  /// At what date is journal, if null - load all values.
  final DateTime? aData = null;

  String apiKey;

  Worker get worker => throw UnimplementedError('BaseJournal worker');

  int get workerDepId => throw UnimplementedError('BaseJournal workerDepId');

  DateTime get _now => DateTime.now();

  DateTime get today => DateTime(_now.year, _now.month, _now.day);

  Future<void> archiveOldServices() async {
    return; // stub
  }

  Future<void> delete({ServiceOfJournal? serv, String? uuid}) async {
    return; // stub
  }

  Future<void> updateBasedOnNewPlanDate() async {
    return; // stub
  }

  Future<bool> post(ServiceOfJournal se) async {
    return false; // stub
  }

  Future<void> commitAll(
      [JournalHttpInterface? httpClient,
      List<ServiceOfJournal>? forSync]) async {
    return; // stub
  }
}
