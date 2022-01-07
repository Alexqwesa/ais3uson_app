import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';

part 'journal.g.dart';

/// ServiceState
///
/// usual life of [ServiceOfJournal] is:
///                 added   -> finished -> outDated -> deleted
///                 stalled -> finished -> outDated -> deleted
///                 [both]  -> rejected ->          -> deleted
///
/// added and stalled | [commit]ed to DB | finished | [deleteOldServices] on next day
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

  bool post(ServiceOfJournal se) {
    all.add(se);
    Future(() async {
      hive = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
      await hive.add(se);
    }).onError((error, stackTrace) {
      showErrorNotification(
        'Ошибка: не удалось сохранить запись журнала, проверьте сводобное место на устройстве',
      );
    });
    commitAll();
    notifyListeners();

    return true;
  }

  /// commit
  ///
  /// try to commit service
  Future<ServiceState?> commit(ServiceOfJournal s) async {
    final urlAddress = 'http://${workerProfile.key.host}:48080/add';
    final url = Uri.parse(urlAddress);
    //
    // > create body of post request
    //
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
      //
      // > check: is it in right state (not finished etc...)
      //
      if (s.state != ServiceState.added || s.state != ServiceState.stalled) {
        return s.state;
      }
      //
      // > send Post
      //
      final response = await http.post(url, headers: httpHeaders, body: body);
      dev.log('$urlAddress response.statusCode = ${response.statusCode}');
      dev.log(response.body);
      //
      // > check response
      //
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty &&
            response.body != 'Wrong authorization key') {
          final res = jsonDecode(response.body) as Map<String, dynamic>;

          return (res['id'] as int) > 0
              ? ServiceState.finished
              : ServiceState.rejected;
        } else {
          return ServiceState.stalled;
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

  /// commitAll
  ///
  /// try to commit all [servicesForSync]
  /// and assign them new states
  Future<void> commitAll() async {
    //
    // > main loop
    //
    final servList = servicesForSync.toList(); // work with copy of list
    for (final s in servList) {
      s.state = await commit(s) ?? s.state;
    }
    notifyListeners();
  }

  Future<void> deleteOldServices() async {
    //
    // > open hive archive and add old services
    //
    final now = DateTime.now();
    final hiveArchive =
        await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');
    await hiveArchive.addAll(
      all.where(
        (el) =>
            el.provDate.difference(now).inDays > 1 &&
            el.state == ServiceState.finished,
      ),
    );
    //
    // > delete finished old services and save hive
    //
    all.removeWhere(
      (el) =>
          el.provDate.difference(now).inDays > 1 &&
          el.state == ServiceState.finished,
    );
    unawaited(save());
    //
    // > only hiveArchiveLimit number of services stored, delete most old and close
    //
    for (var i = 0; i < hiveArchive.length - hiveArchiveLimit; i++) {
      await hiveArchive.deleteAt(i);
    }
    await hiveArchive.compact();
    await hiveArchive.close();
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
