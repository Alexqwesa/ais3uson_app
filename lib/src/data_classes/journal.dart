import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

part 'journal.g.dart';

/// ServiceState
///
/// usual life of [ServiceOfJournal] is:
///                 added   -> finished -> outDated -> [delete]
///                 stalled -> finished -> outDated -> [delete]
///                         -> rejected ->          -> [delete]
///
/// added and stalled | [synced to DB] | finished | [deleted on next day]
/// rejected | [deleted by user]
enum ServiceState { added, stalled, finished, rejected, outDated }

/// Journal
///
/// main repository for services(in various states), provided by worker
// ignore: prefer_mixin
class Journal with ChangeNotifier {
  late final Box<ServiceOfJournal> hive;
  late final String apiKey;
  late final int workerDepId;

  List<ServiceOfJournal> all = [];

  Iterable<ServiceOfJournal> get stalled =>
      all.where((element) => element.state == ServiceState.stalled);

  Iterable<ServiceOfJournal> get finished =>
      all.where((element) => element.state == ServiceState.finished);

  Iterable<ServiceOfJournal> get affect => all.where((element) => [
        ServiceState.stalled,
        ServiceState.added,
        ServiceState.finished,
      ].contains(element.state));

  Journal({
    required this.apiKey,
    required this.workerDepId,
  });

  @override
  void dispose() {
    hive.close();

    return super.dispose();
  }

  Future<void> postInit() async {
    hive = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
    all = hive.values.toList();
    notifyListeners();
  }

  Future<void> save() async {
    // TODO:
  }

  bool add(ServiceOfJournal se) {
    all.add(se);
    notifyListeners();
    save();

    return true;
  }

  Future<void> deleteOldServices() async {
    final now = DateTime.now();
    all.removeWhere((el) => el.provDate.difference(now).inDays > 1);
    await save();
  }
}

/// ServiceOfJournal
///
/// ServiceOfJournal in state [ServiceState.added] the entry that will be send
/// to BD (and it will change state afterward).
@HiveType(typeId: 0)
class ServiceOfJournal with HiveObjectMixin {
  @HiveField(0)
  final int servId;
  @HiveField(1)
  final int contractId;
  @HiveField(2)
  final int workerId;
  @HiveField(3)
  // preinited
  final DateTime provDate = DateTime.now();
  @HiveField(4)
  ServiceState state = ServiceState.added;
  @HiveField(5)
  String error = '';

  ServiceOfJournal({
    required this.servId,
    required this.contractId,
    required this.workerId,
  });
}
