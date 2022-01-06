import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/src/data_classes/worker_profile.dart';
import 'package:ais3uson_app/src/global.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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
  // > main list of services
  //
  List<ServiceOfJournal> all = [];

  String get apiKey => workerProfile.key.apiKey;

  int get workerDepId => workerProfile.key.workerDepId;

  Iterable<ServiceOfJournal> get stalled =>
      all.where((element) => element.state == ServiceState.stalled);

  Iterable<ServiceOfJournal> get finished =>
      all.where((element) => element.state == ServiceState.finished);

  Iterable<ServiceOfJournal> get affect => all.where(
        (element) => [
          ServiceState.stalled,
          ServiceState.added,
          ServiceState.finished,
        ].contains(element.state),
      );

  Iterable<ServiceOfJournal> get servicesForSync => all.where(
        (element) => [
          ServiceState.stalled,
          ServiceState.added,
        ].contains(element.state),
      );

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

  /// commitAll
  ///
  /// try to commit all [servicesForSync]
  /// and assign them new statuses
  Future<void> commitAll() async {
    final urlAddress = 'http://${workerProfile.key.host}:48080/add';
    final url = Uri.parse(urlAddress);
    //
    // > main loop
    //
    final servList = servicesForSync.toList(); // work with copy of list
    for (final s in servList) {
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
      try {
        final response = await http.post(url, headers: httpHeaders, body: body);
        dev.log('$urlAddress response.statusCode = ${response.statusCode}');
        dev.log(response.body);
        if (response.statusCode == 200) {
          if (response.body.isNotEmpty &&
              response.body != 'Wrong authorization key') {
            final res = jsonDecode(response.body) as Map<String, dynamic>;
            s.state = res['id'] as int > 0
                ? ServiceState.finished
                : ServiceState.rejected;
          } else {
            s.state = ServiceState.stalled;
          }
        }
        //
        // > just error handling
        //
      } on ClientException {
        showErrorNotification('Ошибка сервера!');
        dev.log('Server error $urlAddress ');
      } on SocketException {
        showErrorNotification('Ошибка: нет соединения с интернетом!');
        dev.log('No internet connection $urlAddress ');
      } on HttpException {
        showErrorNotification('Ошибка доступа к серверу!');
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
  // > preinited vars
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
