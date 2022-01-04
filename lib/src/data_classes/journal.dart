import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/src/data_classes/worker_profile.dart';
import 'package:ais3uson_app/src/global.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';

part 'journal.g.dart';

/// ServiceState
///
/// usual life of [ServiceOfJournal] is:
///                 added   -> finished -> outDated -> deleted
///                 stalled -> finished -> outDated -> deleted
///                         -> rejected ->          -> deleted
///
/// added and stalled | [synced to DB] | finished | [deleted on next day]
/// rejected | [deleted by user]
@HiveType(typeId: 10)
enum ServiceState {
  @HiveField(0)
  added,
  @HiveField(1)
  stalled,
  @HiveField(2)
  finished,
  @HiveField(3)
  rejected,
  @HiveField(4)
  outDated,
}

/// Journal
///
/// main repository for services(in various states), provided by worker
// ignore: prefer_mixin
class Journal with ChangeNotifier {
  late final WorkerProfile workerProfile;
  late Box<ServiceOfJournal> hive;

  //
  // main list of services
  //
  List<ServiceOfJournal> all = [];

  String get apiKey => workerProfile.key.apiKey;

  int get workerDepId => workerProfile.key.workerDepId;

  Iterable<ServiceOfJournal> get stalled =>
      all.where((element) => element.state == ServiceState.stalled);

  Iterable<ServiceOfJournal> get finished =>
      all.where((element) => element.state == ServiceState.finished);

  Iterable<ServiceOfJournal> get affect => all.where((element) => [
        ServiceState.stalled,
        ServiceState.added,
        ServiceState.finished,
      ].contains(element.state));

  Iterable<ServiceOfJournal> get servForSync => all.where((element) => [
        ServiceState.stalled,
        ServiceState.added,
      ].contains(element.state));

  Journal(this.workerProfile);

  @override
  void dispose() {
    // if (hive.isOpen) {
    hive
      ..clear()
      ..addAll(all)
      ..compact()
      ..close();
    // }

    return super.dispose();
  }

  Future<void> postInit() async {
    hive = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
    all = hive.values.toList();
    notifyListeners();
  }

  Future<void> save() async {
    hive = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
    await hive.clear();
    await hive.addAll(all);
    await hive.compact();
  }

  bool add(ServiceOfJournal se) {
    all.add(se);
    Future(() async {
      hive = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
      await hive.add(se);
    });
    commitAll();
    notifyListeners();

    return true;
  }

  Future<void> commitAll() async {
    for (final s in servForSync) {
      final body = jsonEncode(
        <String, dynamic>{
          'api_key': apiKey,
          'vdate': sqlFormat.format(s.provDate),
          'uuid': s.uid,
          'contracts_id': s.contractId,
          'dep_has_worker_id': s.workerId,
          'serv_id': s.servId,
        },
      );
      final urlAddress = 'http://${workerProfile.key.host}:48080/add';
      try {
        final url = Uri.parse(urlAddress);
        final response = await http.post(url, headers: httpHeaders, body: body);
        dev.log('$urlAddress response.statusCode = ${response.statusCode}');
        if (response.statusCode == 200) {
          if (response.body.isNotEmpty && response.body != '[]') {}
        }
        //
        // just error handling
        //
      } on ClientException {
        showSimpleNotification(
          const Text('Ошибка сервера!'),
          background: Colors.red[300],
          position: NotificationPosition.bottom,
        );
        dev.log('Server error $urlAddress ');
      } on SocketException {
        showSimpleNotification(
          const Text('Ошибка: нет соединения с интернетом!'),
          background: Colors.red[300],
          position: NotificationPosition.bottom,
        );
        dev.log('No internet connection $urlAddress ');
      } on HttpException {
        showSimpleNotification(
          const Text('Ошибка доступа к серверу!'),
          background: Colors.red[300],
          position: NotificationPosition.bottom,
        );
        dev.log('Server access error $urlAddress ');
      } finally {
        dev.log('sync ended $urlAddress ');
      }
    }
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
  //
  // preinited vars
  //
  DateTime provDate = DateTime.now();
  @HiveField(4)
  ServiceState state = ServiceState.added;
  @HiveField(5)
  String error = '';
  @HiveField(6)
  String uid = uuid.v4();

  ServiceOfJournal({
    required this.servId,
    required this.contractId,
    required this.workerId,
  });
}
