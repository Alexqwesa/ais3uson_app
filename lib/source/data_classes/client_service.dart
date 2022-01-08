import 'package:ais3uson_app/source/from_json/fio_planned.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:flutter/material.dart';

// ignore: prefer_mixin
class ClientService with ChangeNotifier {
  late final ServiceEntry service;
  late final FioPlanned planned;
  late final int workerDepId;
  late final int depId;

  late final Journal journal;

  int get contractId => planned.contractId;

  int get servId => planned.servId;

  int get plan => planned.planned;

  int get filled => planned.filled;

  int get subServ => service.subServ;

  String get servText => service.servText;

  String get servTextAdd => service.servTextAdd;

  String get shortText => service.shortText;

  int get done => journal.finished
      .where((element) =>
          element.contractId == contractId && element.servId == service.id)
      .length;

  int get stalled => journal.servicesForSync
      .where((element) =>
          element.contractId == contractId && element.servId == service.id)
      .length;

  int get rejected => journal.rejected
      .where((element) =>
          element.contractId == contractId && element.servId == service.id)
      .length;

  int get left => plan - filled - stalled - done;

  List<int> get listDoneProgressError => <int>[done, stalled, rejected];

  String get image => service.image;

  ClientService({
    required this.journal,
    required this.service,
    required this.planned,
    required this.workerDepId,
  }) {
    journal.addListener(notifyListeners);
  }

  Future<void> add() async {
    journal.post(
      ServiceOfJournal(
        servId: planned.servId,
        contractId: planned.contractId,
        workerId: workerDepId,
      ),
    );
    notifyListeners();
  }

  Future<void> delete() async {
    await journal.deleteLast(
      servId: planned.servId,
      contractId: planned.contractId,
    );
    notifyListeners();
  }
}
