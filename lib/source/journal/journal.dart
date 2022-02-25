/// Just journal of user inputted services.
///
/// It is local for each [WorkerProfile].
// ignore: library_names
library Journal;

import 'dart:convert';
import 'dart:io';

import 'package:ais3uson_app/main.dart';
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
  List<ServiceOfJournal> added = [];
  List<ServiceOfJournal> finished = [];
  List<ServiceOfJournal> outDated = [];
  List<ServiceOfJournal> rejected = [];

  String get apiKey => workerProfile.key.apiKey;

  int get workerDepId => workerProfile.key.workerDepId;

  Iterable<ServiceOfJournal> get affect => added + finished;

  Iterable<ServiceOfJournal> get servicesForSync => added;

  Iterable<ServiceOfJournal> get all =>
      [...added, ...finished, ...rejected, ...outDated];

  DateTime get now => DateTime.now();

  DateTime get today => DateTime(now.year, now.month, now.day);

  Iterable<ServiceOfJournal> get _forDelete =>
      (finished + outDated).where((el) => el.provDate.isBefore(today));

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
    hive.values.forEach((element) {
      switch (element.state) {
        case ServiceState.added:
          added.add(element);
          break;
        case ServiceState.finished:
          finished.add(element);
          break;
        case ServiceState.rejected:
          rejected.add(element);
          break;
        case ServiceState.outDated:
          outDated.add(element);
          break;
        default:
          throw StateError('wrong ServiceState');
      }
    });
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
        log.severe('can not save $s');
      }
    }
    await hive.compact();
  }

  Future<bool> post(ServiceOfJournal se) async {
    added.add(se);
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
    if (ServiceState.added != serv.state) {
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
    var ret = ServiceState.added;
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
      log.info(
        '$url response.statusCode = ${response.statusCode}\n\n ${response.body}',
      );
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
          ret = ServiceState.added;
        }
      }
      //
      // > just error handling
      //
    } on HandshakeException {
      showErrorNotification('Ошибка защищенного соединения!');
      log.severe('Server HandshakeException error $url ');
    } on ClientException {
      showErrorNotification('Ошибка сервера!');
      log.severe('Server error  $url  ');
    } on SocketException {
      showErrorNotification('Ошибка: нет соединения с интернетом!');
      log.warning('No internet connection $url ');
    } on HttpException {
      showErrorNotification('Ошибка доступа к серверу!');
      log.severe('Server access error $url ');
    } finally {
      log.fine('sync ended $url ');
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
      await Future.wait(servicesForSync.map((s) async {
        try {
          switch (await commitAdd(s)) {
            case ServiceState.added:
              log.info('stale service $s');
              break; // no changes - do nothing
            case ServiceState.finished:
              log.finest('stale service $s');
              finished.add(s.copyWith(state: ServiceState.finished));
              added.remove(s);
              await s.delete();
              break;
            case ServiceState.rejected:
              log.warning('stale service $s');
              rejected.add(s.copyWith(state: ServiceState.rejected));
              added.remove(s);
              await s.delete();
              break;
            case ServiceState.outDated:
              throw StateError('commit can not make service outDated');
            default:
              throw StateError('impossible');
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          log.severe('Sync services: $e');
        }
      }));

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
    serv ??= all.firstWhereOrNull((element) => element.uid == uuid);
    if (serv == null) {
      log.severe('Error: delete: not found by uuid');

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
      await deleteService([serv]);
      notifyListeners();
      // ignore: avoid_catching_errors
    } on RangeError {
      log.severe('RangeError double delete');
    }
  }

  Future<void> deleteService(List<ServiceOfJournal> forDelete) async {
    forDelete.forEach((e) {
      switch (e.state) {
        case ServiceState.added:
          added.remove(e);
          break;
        case ServiceState.finished:
          finished.remove(e);
          break;
        case ServiceState.rejected:
          rejected.remove(e);
          break;
        case ServiceState.outDated:
          outDated.remove(e);
          break;
        default:
          throw StateError('Impossible state');
      }

      e.delete();
    });
    await save();
  }

  /// This function move old finished(and outDated) services to [hiveArchive].
  ///
  /// There are two reason to archive services,
  /// first - we want active hiveBox small and fast on all devices,
  /// second - we want worker to only see today's services, and
  /// services which didn't committed yet(stale/rejected).
  ///
  /// Archive is only for committed services.
  /// Only [AppData.instance.hiveArchiveLimit] number of services could be stored in archive, most old will be deleted first.
  Future<void> archiveOldServices() async {
    //
    // > open hive archive and add old services
    //
    hiveArchive =
        await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');
    final forDelete = _forDelete.toList(); // don't lose this list after delete
    final forArchive = forDelete.map((e) => e.copyWith());
    if (forArchive.isNotEmpty) {
      await hiveArchive.addAll(forArchive); // check duplicates error
      //
      // > delete finished old services and save hive
      //
      await deleteService(forDelete);
      //
      // > only [hiveArchiveLimit] number of services stored, delete most old and close
      //
      // todo: check if hiveArch always place new services last, in that case we can just use deleteAt()
      final archList = hiveArchive.values.toList()
        ..sort((a, b) => a.provDate.compareTo(b.provDate))
        ..reversed;
      final hiveArchiveLimit = AppData().hiveArchiveLimit;
      if (hiveArchive.length > hiveArchiveLimit) {
        await hiveArchive.deleteAll(
          archList.slice(hiveArchiveLimit).map<dynamic>((e) => e.key),
        );
      }
      final dateList = archList
          .slice(
            0,
            hiveArchiveLimit < archList.length
                ? hiveArchiveLimit
                : archList.length,
          )
          .map((element) => element.provDate)
          .toList();
      await AppData.instance.hiveData.put(
        'archiveDates_$apiKey',
        dateList,
      );
      AppData.instance.datesInArchive.addAll(dateList);
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
          (element) => element.state == ServiceState.added,
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
      log.severe(
        'Error: $e, can not delete service #$servId of contract #$contractId',
      );
    }

    return null;
  }

  /// Mark all finished service as [ServiceState.outDated]
  /// after [WorkerProfile._clientPlan] synchronized.
  Future<void> updateBasedOnNewPlanDate() async {
    added.where((e) => e.state == ServiceState.finished).forEach(
      (element) async {
        // TODO: rework it?
        if (element.provDate
            .isBefore(await workerProfile.clientPlanSyncDate())) {
          outDated.add(element.copyWith(state: ServiceState.outDated));
          await deleteService([element]);
        }
      },
    );
  }
}
