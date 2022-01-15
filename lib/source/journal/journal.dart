/// Just journal of user inputted services.
///
/// It is local for each [WorkerProfile].
library Journal;

import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:surf_lint_rules/surf_lint_rules.dart';
import 'package:synchronized/synchronized.dart';

/// Journal of services
///
/// This is a main repository for services (in various states),
/// it is member of [WorkerProfile] class.
///
/// ![Mind map of it functionality](https://raw.githubusercontent.com/Alexqwesa/ais3uson_app/master/lib/source/journal/journal.png)
///
/// {@category Journal}
// ignore: prefer_mixin
class Journal with ChangeNotifier {
  late final WorkerProfile workerProfile;
  final _lock = Lock();
  late Box<ServiceOfJournal> hive;
  late Box<ServiceOfJournal> hiveArchive;

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

  Iterable<ServiceOfJournal> get rejected =>
      all.where((element) => element.state == ServiceState.rejected);

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
    () async {
      await hive.clear();
      await hive.addAll(all);
      await hive.compact();
      await hive.close();
    }();

    return super.dispose();
  }

  Future<void> postInit() async {
    hive = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
    all = hive.values.toList();
    await archiveOldServices();
    notifyListeners();
  }

  Future<void> save() async {
    hive = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
    for (final s in all) {
      try {
        await hive.add(s);
      } on HiveError {
        await s.save();
      }
    }
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

    return true;
  }

  /// Try to commit service(send http post request).
  ///
  /// Return new state or null, didn't change service state.
  /// On error: show [showErrorNotification] to user.
  Future<ServiceState?> commit(ServiceOfJournal serv, {String? body}) async {
    final urlAddress =
        'http://${workerProfile.key.host}:${workerProfile.key.port}/add';
    final url = Uri.parse(urlAddress);
    //
    // > create body of post request
    //
    // ignore: parameter_assignments
    body ??= jsonEncode(
      <String, dynamic>{
        'api_key': apiKey,
        'check_api_key': apiKey,
        'vdate': sqlFormat.format(serv.provDate),
        'uuid': serv.uid,
        'contracts_id': serv.contractId,
        'dep_has_worker_id': serv.workerId,
        'serv_id': serv.servId,
      },
    );
    try {
      //
      // > check: is it in right state (not finished etc...)
      //
      if (![ServiceState.added, ServiceState.stalled].contains(serv.state)) {
        return serv.state;
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

  /// Try to commit all [servicesForSync].
  ///
  /// It works via [commit],
  /// it change state of services and called [notifyListeners] afterward.
  Future<void> commitAll() async {
    //
    // > main loop, synchronized
    //
    await _lock.synchronized(() async {
      final servList = servicesForSync.toList(); // work with copy of list
      try {
        for (final s in servList) {
          s.state = await commit(s) ?? s.state;
        }
        servList.forEach((element) => dev.log(element.state.toString()));
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        dev.log(e.toString());
      }
      notifyListeners();
    });
  }

  /// Delete service [serv] from journal.
  ///
  /// Also notify listeners and save.
  Future<void> delete({ServiceOfJournal? serv, String? uuid}) async {
    //
    // find service
    //
    serv ??= all.lastWhereOrNull((element) => element.uid == uuid);
    if (serv == null) {
      dev.log('Error: delete: not found by uuid');

      return;
    }
    //
    // delete from DB if needed
    //
    if ([
      ServiceState.finished,
      ServiceState.outDated,
    ].contains(serv.state)) {
      final body = jsonEncode(
        <String, dynamic>{
          'api_key': apiKey,
          'uuid': serv.uid,
          'contracts_id': serv.contractId,
          'dep_has_worker_id': serv.workerId,
          'serv_id': serv.servId,
        },
      );
      await commit(serv, body: body);
    }
    //
    // delete
    //
    all.removeAt(
      all.indexOf(serv),
    );
    notifyListeners();
    unawaited(save());
  }

  Future<void> archiveOldServices() async {
    //
    // > open hive archive and add old services
    //
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    hiveArchive =
        await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');
    await hiveArchive.addAll(
      all
          .where(
            (el) =>
                el.provDate.isBefore(today) &&
                [ServiceState.finished, ServiceState.outDated]
                    .contains(el.state),
          )
          .map((e) => ServiceOfJournal.copy(
                servId: e.servId,
                contractId: e.contractId,
                workerId: e.workerId,
                state: e.state,
                uid: e.uid,
                error: e.error,
                provDate: e.provDate,
              )),
      /*
            We could have just removed element first from list of active element,
            but this could lead to dataloss,
            this code can lead to data duplicate, but we can: TODO: deduplicate data on load
            */
    );
    //
    // > delete finished old services and save hive
    //
    all.removeWhere(
      (el) => el.provDate.isBefore(today) && el.state == ServiceState.finished,
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

  String? getUuidOfLastService({
    required int servId,
    required int contractId,
  }) {
    try {
      final serv = all.lastWhere(
        (element) =>
            element.servId == servId && element.contractId == contractId,
      );
      final uid = serv.uid;

      return uid;
      // ignore: avoid_catching_errors
    } on StateError catch (e) {
      dev.log('Error: $e, can not delete $servId of contract $contractId');
    }
  }
}
