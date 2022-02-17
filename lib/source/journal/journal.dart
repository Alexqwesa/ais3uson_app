/// Just journal of user inputted services.
///
/// It is local for each [WorkerProfile].
// ignore: library_names
library Journal;

import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
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
  late final Map<String, String> _httpHeaders;
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

  Iterable<ServiceOfJournal> get added =>
      all.where((element) => element.state == ServiceState.added);

  Iterable<ServiceOfJournal> get finished =>
      all.where((element) => element.state == ServiceState.finished);

  Iterable<ServiceOfJournal> get rejected =>
      all.where((element) => element.state == ServiceState.rejected);

  Iterable<ServiceOfJournal> get outDated =>
      all.where((element) => element.state == ServiceState.outDated);

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

  Journal(this.workerProfile) {
    _httpHeaders = {}
      ..addAll(httpHeaders)
      ..addAll({'api_key': apiKey});
  }

  @override
  void dispose() {
    if (hive.isOpen) {
      () async {
        await hive.compact();
        await hive.close();
      }();
    }

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
        await s.save();
        // ignore: avoid_catching_errors, avoid_catches_without_on_clauses
      } catch (e) {
        dev.log('can not save $s');
      }
    }
    await hive.compact();
  }

  Future<bool> post(ServiceOfJournal se) async {
    all.add(se);
    try {
      hive = await Hive.openBox<ServiceOfJournal>('journal_$apiKey');
      await hive.add(se);
      // ignore: avoid_catching_errors, avoid_catches_without_on_clauses
    } catch (e) {
      showErrorNotification(
        'Ошибка: не удалось сохранить запись журнала, проверьте сводобное место на устройстве',
      );
    }
    await commitAll();

    return true;
  }

  /// Delete service from DB.
  ///
  /// Create request body and call [commitUrl].
  Future<ServiceState?> commitDel(ServiceOfJournal serv) async {
    //
    // > create body of post request
    //
    final body = jsonEncode(
      <String, dynamic>{
        'uuid': serv.uid,
        'serv_id': serv.servId,
        'contracts_id': serv.contractId,
        'dep_has_worker_id': serv.workerId,
      },
    );
    //
    // > send Post
    //
    final urlAddress =
        'http://${workerProfile.key.host}:${workerProfile.key.port}/delete';

    return commitUrl(urlAddress, body: body);
  }

  /// Add service to DB.
  ///
  /// Create request body and call [commitUrl].
  Future<ServiceState?> commitAdd(ServiceOfJournal serv, {String? body}) async {
    //
    // > create body of post request
    //
    // ignore: parameter_assignments
    body ??= jsonEncode(
      <String, dynamic>{
        'vdate': sqlFormat.format(serv.provDate),
        'uuid': serv.uid,
        'contracts_id': serv.contractId,
        'dep_has_worker_id': serv.workerId,
        'serv_id': serv.servId,
      },
    );
    //
    // > check: is it in right state (not finished etc...)
    //
    if (![ServiceState.added, ServiceState.stalled].contains(serv.state)) {
      return serv.state;
    }
    //
    // > send Post
    //
    final urlAddress =
        'http://${workerProfile.key.host}:${workerProfile.key.port}/add';

    return commitUrl(urlAddress, body: body);
  }

  /// Try to commit service(send http post request).
  ///
  /// Return new state or null, didn't change service state itself.
  /// On error: show [showErrorNotification] to user.
  Future<ServiceState?> commitUrl(String urlAddress, {String? body}) async {
    var url = Uri.parse(urlAddress);
    var http = AppData().httpClient;
    var ret = ServiceState.stalled;
    try {
      Response response;
      final sslClient = workerProfile.sslClient;
      if (kIsWeb) {
        url = Uri.parse(urlAddress.replaceFirst('http', 'https'));
      } else if (sslClient != null) {
        http = IOClient(sslClient);
        url = Uri.parse(urlAddress.replaceFirst('http', 'https'));
      }

      if (urlAddress.endsWith('/add')) {
        response = await http.post(url, headers: _httpHeaders, body: body);
      } else if (urlAddress.endsWith('/delete')) {
        response = await http.delete(url, headers: _httpHeaders, body: body);
      } else {
        response = await http.get(url, headers: _httpHeaders);
      }
      dev.log('$urlAddress response.statusCode = ${response.statusCode}');
      dev.log(response.body);
      //
      // > check response
      //
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty &&
            response.body != 'Wrong authorization key') {
          final res = jsonDecode(response.body) as Map<String, dynamic>;

          ret = (res['id'] as int) > 0
              ? ServiceState.finished
              : ServiceState.rejected;
        } else {
          ret = ServiceState.stalled;
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

    return ret;
  }

  /// Try to commit all [servicesForSync].
  ///
  /// It works via [commitAdd],
  /// it change state of services and called [notifyListeners] afterward.
  Future<void> commitAll() async {
    //
    // > main loop, synchronized
    //
    await _lock.synchronized(() async {
      final servList = servicesForSync.toList(); // work with copy of list
      try {
        for (final s in servList) {
          await s.setState(await commitAdd(s) ?? s.state);
        }
        servList.forEach((element) => dev.log(element.state.toString()));
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        dev.log(e.toString());
      }
      notifyListeners();
    });
  }

  /// Delete service [serv] (or find serv by [uuid]) from journal.
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
      await commitDel(serv);
    }
    //
    // delete
    //
    try {
      all.removeAt(
        all.indexOf(serv),
      );
      notifyListeners();
      await serv.delete();
      // ignore: avoid_catching_errors
    } on RangeError {
      dev.log('RangeError double delete');
    }
  }

  /// This function move old finished(and outDated) services to [hiveArchive].
  ///
  /// There are two reason to archive services,
  /// first - we want active hiveBox small and fast on all devices,
  /// second - we want worker to only see today's services, and
  /// services which didn't committed yet(stale/rejected).
  ///
  /// Archive is only for committed services.
  /// Only [hiveArchiveLimit] number of services could be stored in archive, most old will be deleted first.
  Future<void> archiveOldServices() async {
    //
    // > open hive archive and add old services
    //
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    hiveArchive =
        await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');
    /*
      We could have just removed element first from list of active elements,
      but this could lead to dataloss,
      this code can lead to data duplication, but we can: TODO: deduplicate data on load.
      This is low priority since it can only happen if sudden kill of app happen in exact this moment.
    */
    final forDelete = all.where(
      (el) =>
          el.provDate.isBefore(today) &&
          [ServiceState.finished, ServiceState.outDated].contains(el.state),
    );
    final forArchive = forDelete.map(
      (e) => ServiceOfJournal.copy(
        servId: e.servId,
        contractId: e.contractId,
        workerId: e.workerId,
        state: e.state,
        uid: e.uid,
        error: e.error,
        provDate: e.provDate,
      ),
    );
    if (forArchive.isNotEmpty) {
      await hiveArchive.addAll(forArchive);
      //
      // > delete finished old services and save hive
      //
      forDelete.forEach((e) {
        e.delete();
      });
      all.removeWhere(forDelete.contains);
      await save();
      //
      // > only [hiveArchiveLimit] number of services stored, delete most old and close
      //
      // todo: check if hiveArch always place new services last, in that case we can just use deleteAt()
      if (hiveArchive.length > hiveArchiveLimit) {
        final archList = hiveArchive.values.toList();
        archList
          ..sort((a, b) => a.provDate.isBefore(b.provDate) ? 1 : -1)
          ..removeRange(hiveArchiveLimit, archList.length);
        await hiveArchive.deleteFromDisk(); // or maybe better deleteAll ?
        hiveArchive =
            await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');
        await hiveArchive.addAll(archList);
      }
      await hiveArchive.compact();
      await hiveArchive.close();
    }
  }

  /// Helper, only used in [ClientService], for deleting last [ServiceOfJournal].
  ///
  /// It return rejected services first, then stalled, then finished, then outdated.
  String? getUuidOfLastService({
    required int servId,
    required int contractId,
  }) {
    try {
      final servList = all.where(
        (element) =>
            element.servId == servId && element.contractId == contractId,
      );
      final serv = servList.lastWhere(
        (element) => element.state == ServiceState.rejected,
        orElse: () => servList.lastWhere(
          (element) => element.state == ServiceState.stalled,
          orElse: () => servList.lastWhere(
            (element) => element.state == ServiceState.finished,
            orElse: () => servList.lastWhere(
              (element) => element.state == ServiceState.outDated,
            ),
          ),
        ),
      );
      final uid = serv.uid;

      return uid;
      // ignore: avoid_catching_errors
    } on StateError catch (e) {
      dev.log(
        'Error: $e, can not delete service #$servId of contract #$contractId',
      );
    }

    return null;
  }

  /// Mark all finished service as [ServiceState.outDated]
  /// after [WorkerProfile._clientPlan] synchronized.
  Future<void> updateBasedOnNewPlanDate() async {
    all.where((e) => e.state == ServiceState.finished).forEach(
      (element) async {
        // TODO: rework it?
        if (element.provDate.isBefore(workerProfile.clientPlan[0].checkDate)) {
          await element.setState(ServiceState.outDated);
        }
      },
    );
  }
}
