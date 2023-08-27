import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';

/// Base class for [Journal] classes.
abstract class BaseJournal {
  BaseJournal(this.workerProfile);

  /// At what date is journal, if null - load all values.
  final DateTime? aData = null;

  late final Worker workerProfile;

  String get apiKey => workerProfile.key.apiKey;

  int get workerDepId => workerProfile.key.workerDepId;

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

  Future<void> commitAll() async {
    return; // stub
  }
}
