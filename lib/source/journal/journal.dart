/// Just journal of user inputted services.
///
/// It is local for each [WorkerProfile].
// ignore: library_names
library Journal;

import 'dart:convert';
import 'dart:io';

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/source/providers.dart';
import 'package:ais3uson_app/source/providers/dates_in_archive.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:share_plus/share_plus.dart';
import 'package:synchronized/synchronized.dart';
import 'package:universal_html/html.dart' as html;

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

  String get journalHiveName => 'journal_$apiKey';

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
    hive = await Hive.openBox<ServiceOfJournal>(journalHiveName);
    final groups =
        groupBy<ServiceOfJournal, ServiceState>(hive.values, (e) => e.state);
    added = groups[ServiceState.added] ?? [];
    finished = groups[ServiceState.finished] ?? [];
    rejected = groups[ServiceState.rejected] ?? [];
    outDated = groups[ServiceState.outDated] ?? [];
    await archiveOldServices();
    notifyListeners();
  }

  /// Return json String with all [ServiceOfJournal] between dates [start] and [end].
  ///
  /// It gets values from both hive and hiveArchive.
  /// The [end] date is not included, the dates [DateTime] should be rounded to zero time.
  Future<String> export(DateTime start, DateTime end) async {
    await save();
    hive = await Hive.openBox<ServiceOfJournal>(journalHiveName);
    hiveArchive =
        await Hive.openBox<ServiceOfJournal>('journal_archive_$apiKey');

    return jsonEncode([
      {'api_key': workerProfile.apiKey},
      ...hive.values
          .where((s) => s.provDate.isAfter(start) && s.provDate.isBefore(end))
          .map((e) => e.toJson()),
      ...hiveArchive.values
          .where((s) => s.provDate.isAfter(start) && s.provDate.isBefore(end))
          .map((e) => e.toJson()),
    ]);
  }

  Future<void> exportToFile(DateTime start, DateTime end) async {
    final content = await export(start, end);
    // final _base64 = base64Encode(content.codeUnits);
    final fileName =
        '${workerDepId}_${workerProfile.key.dep}_${workerProfile.key.name}_'
        '${standardFormat.format(start)}_${standardFormat.format(end)}.ais_json';
    final filePath = await getSafePath([fileName]);
    if (filePath == null) {
      if (kIsWeb) {
        final blob = html.Blob(
          <String>[content],
          'text/json',
          'native',
        );

        html.AnchorElement(
          href: html.Url.createObjectUrlFromBlob(blob).toString(),
        )
          ..setAttribute('download', fileName)
          ..click();
      }
    } else {
      File(filePath).writeAsStringSync(content);
      try {
        await Share.shareFiles([filePath]);
      } on MissingPluginException {
        showNotification(
          locator<S>().fileSavedTo + filePath,
          duration: const Duration(seconds: 10),
        );
      }
    }
  }

  Future<void> save() async {
    hive = await Hive.openBox<ServiceOfJournal>(journalHiveName);
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

  /// Add new [ServiceOfJournal] to [Journal] and call [commitAll].
  Future<bool> post(ServiceOfJournal se) async {
    added.add(se);
    try {
      hive = await Hive.openBox<ServiceOfJournal>(journalHiveName);
      await hive.add(se);
      // ignore: avoid_catching_errors, avoid_catches_without_on_clauses
    } catch (e) {
      showErrorNotification(
        'Ошибка: не удалось сохранить запись журнала, проверьте сводобное место на устройстве',
      );
      await commitAll(); // still call?

      return false;
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
    final k = workerProfile.key;
    final urlAddress = '${k.activeServer}/delete';

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
    final k = workerProfile.key;
    final urlAddress = '${k.activeServer}/add';

    return commitUrl(urlAddress, body: body);
  }

  /// Try to commit service(send http post request).
  ///
  /// Return new state or null, didn't change service state itself.
  /// On error: show [showErrorNotification] to user.
  ///
  /// Note for web platform:
  /// Https is always used for web platform, because:
  /// get real ssl certificate is much easier and safer
  /// than configure browser to accept self-signed certificate on all clients,
  /// or find host without https support.
  ///
  /// {@category Network}
  Future<ServiceState?> commitUrl(String urlAddress, {String? body}) async {
    final url = Uri.parse(urlAddress);
    var http = workerProfile.httpClient;
    var ret = ServiceState.added;
    try {
      Response response;
      final sslClient = workerProfile.sslClient;
      if (sslClient != null) {
        http = IOClient(sslClient);
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
      showErrorNotification(locator<S>().sslError);
      log.severe('Server HandshakeException error $url ');
    } on ClientException {
      showErrorNotification(locator<S>().serverError);
      log.severe('Server error  $url  ');
    } on SocketException {
      showErrorNotification(locator<S>().internetError);
      log.warning('No internet connection $url ');
    } on HttpException {
      showErrorNotification(locator<S>().httpAccessError);
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
      await Future.wait(servicesForSync.map((serv) async {
        try {
          switch (await commitAdd(serv)) {
            case ServiceState.added:
              log.info('stale service $serv');
              break; // no changes - do nothing
            case ServiceState.finished:
              log.finest('finished service $serv');
              toFinished(serv);
              break;
            case ServiceState.rejected:
              log.warning('rejected service $serv');
              toRejected(serv);
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
  /// Note: since services are deleted by uuid double deletes is not a problem.
  /// (Async lock is not needed.)
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
      toDelete([serv]);
      notifyListeners();
      // ignore: avoid_catching_errors
    } on RangeError {
      log.info('RangeError double delete');
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
  /// Only hiveArchiveLimit number of services could be stored in archive, most old will be deleted first.
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
      toDelete(forDelete);
      //
      // > only [archiveLimit] number of services stored, delete most old and close
      //
      // todo: check if hiveArch always place new services last, in that case we can just use deleteAt()
      final archList = hiveArchive.values.toList()
        ..sort((a, b) => a.provDate.compareTo(b.provDate))
        ..reversed;
      final archiveLimit = workerProfile.ref.read(hiveArchiveLimit);
      if (hiveArchive.length > archiveLimit) {
        await hiveArchive.deleteAll(
          archList.slice(archiveLimit).map<dynamic>((e) => e.key),
        );
      }
      final dateList = archList
          .slice(
            0,
            archiveLimit < archList.length ? archiveLimit : archList.length,
          )
          .map((element) => element.provDate)
          .toList();
       // workerProfile.ref.read(hiveDate).put(
       //      'archiveDates_$apiKey',
       //      dateList,
       //    );
      workerProfile.ref.read(innerDatesInArchive.notifier).addAll(
            dateList.map((e) => DateTime(e.year, e.month, e.day)),
          );
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
    await _lock.synchronized(() async {
      finished.forEach(
        (element) async {
          // TODO: rework it?
          if (element.provDate
              .isBefore(await workerProfile.clientPlanSyncDate())) {
            toOutDated(element);
          }
        },
      );
    });
  }

  /// Remove [ServiceOfJournal] from lists of [Journal] and from Hive.
  void toDelete(List<ServiceOfJournal> forDelete) {
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
    notifyListeners();
  }

  /// Shortcut for [moveServiceTo].
  ServiceOfJournal toOutDated(ServiceOfJournal service) =>
      moveServiceTo(service, ServiceState.outDated);

  /// Shortcut for [moveServiceTo].
  ServiceOfJournal toRejected(ServiceOfJournal service) =>
      moveServiceTo(service, ServiceState.rejected);

  /// Shortcut for [moveServiceTo].
  ServiceOfJournal toFinished(ServiceOfJournal service) =>
      moveServiceTo(service, ServiceState.finished);

  /// Move service - create new in dst, delete old in src list of [Journal].
  ///
  /// Take care of [Journal] lists and Hive.
  ServiceOfJournal moveServiceTo(
    ServiceOfJournal service,
    ServiceState newState,
  ) {
    //
    // > remove
    //
    switch (service.state) {
      case ServiceState.added:
        added.remove(service);
        break;
      case ServiceState.finished:
        finished.remove(service);
        break;
      case ServiceState.rejected:
        rejected.remove(service);
        break;
      case ServiceState.outDated:
        outDated.remove(service);
        break;
      default:
        throw StateError('Impossible state');
    }
    //
    // > add
    //
    final newService = service.copyWith(state: newState);
    switch (newService.state) {
      case ServiceState.added:
        added.add(newService);
        break;
      case ServiceState.finished:
        finished.add(newService);
        break;
      case ServiceState.rejected:
        rejected.add(newService);
        break;
      case ServiceState.outDated:
        outDated.add(newService);
        break;
      default:
        throw StateError('Impossible state');
    }
    hive.add(newService);
    newService.save();
    service.delete();
    notifyListeners();

    return newService;
  }
}
