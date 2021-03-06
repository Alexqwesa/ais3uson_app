import 'dart:convert';
import 'dart:io';

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
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
/// {@category Client-Server API}
// ignore: prefer_mixin
class Journal {
  Journal(this.workerProfile);

  /// At what date is journal, null - load all values.
  final DateTime? aData = null;

  late final WorkerProfile workerProfile;
  final _lock = Lock();
  late Box<ServiceOfJournal> hive; // only for test
  late Box<ServiceOfJournal> hiveArchive; // todo: use provider

  String get journalHiveName => 'journal_$apiKey';

  ProviderContainer get ref => workerProfile.ref;

  String get apiKey => workerProfile.key.apiKey;

  int get workerDepId => workerProfile.key.workerDepId;

  //
  // > main list of services
  //
  ServicesListState get servicesProvider =>
      ref.read(servicesOfJournal(this).notifier);

  List<ServiceOfJournal> get all => ref.read(servicesOfJournal(this)) ?? [];

  List<ServiceOfJournal> get added =>
      ref.read(groupsOfJournal(this))[ServiceState.added] ?? [];

  List<ServiceOfJournal> get finished =>
      ref.read(groupsOfJournal(this))[ServiceState.finished] ?? [];

  List<ServiceOfJournal> get outDated =>
      ref.read(groupsOfJournal(this))[ServiceState.outDated] ?? [];

  List<ServiceOfJournal> get rejected =>
      ref.read(groupsOfJournal(this))[ServiceState.rejected] ?? [];

  List<ServiceOfJournal> get servicesForSync => added;

  DateTime get now => DateTime.now();

  DateTime get today => DateTime(now.year, now.month, now.day);

  Iterable<ServiceOfJournal> get _forArchive =>
      (finished + outDated).where((el) => el.provDate.isBefore(today));

  /// Only for tests! Don't use in real code.
  Future<void> postInit() async {
    //
    // > read hive at date or all
    //
    // await ref.read(datesInArchive.future);
    await servicesProvider.initAsync();
    hive = ref.read(hiveJournalBox(journalHiveName)).value!;
  }

  /// Return json String with [ServiceOfJournal] between dates [start] and [end]
  ///
  /// It gets values from both hive and hiveArchive.
  /// The [end] date is not included,
  ///  the dates [DateTime] should be rounded to zero time.
  Future<String> export(DateTime start, DateTime end) async {
    // await save();
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
    final fileName =
        '${workerDepId}_${workerProfile.key.dep}_${workerProfile.key.name}_'
        '${standardFormat.format(start)}_'
        '${standardFormat.format(end)}.ais_json';
    //
    // > for web - just download
    //
    if (kIsWeb) {
      final blob = html.Blob(
        <String>[content],
        'text/json',
        'native',
      );
      html.AnchorElement(href: html.Url.createObjectUrlFromBlob(blob))
        ..setAttribute('download', fileName)
        ..click();
    } else {
      //
      // > save and try to share
      //
      final filePath = await getSafePath([fileName]);
      if (filePath == null) {
        showNotification(tr().errorSave);
      } else {
        File(filePath).writeAsStringSync(content);
        try {
          await Share.shareFiles([filePath]);
          // ignore: avoid_catching_errors
        } on UnimplementedError {
          showNotification(
            tr().fileSavedTo + filePath,
            duration: const Duration(seconds: 10),
          );
        } on MissingPluginException {
          showNotification(
            tr().fileSavedTo + filePath,
            duration: const Duration(seconds: 10),
          );
        }
      }
    }
  }

  /// Add new [ServiceOfJournal] to [Journal] and call [commitAll].
  Future<bool> post(ServiceOfJournal se) async {
    try {
      await servicesProvider.post(se);
      // ignore: avoid_catching_errors, avoid_catches_without_on_clauses
    } catch (e) {
      showErrorNotification(tr().errorSave);
      await commitAll(); // still call?

      return false;
    }
    await commitAll();

    return true;
  }

  /// Delete service from remote DB.
  ///
  /// Create request body and call [_commitUrl].
  Future<ServiceState?> _commitDel(ServiceOfJournal serv) async {
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

    return _commitUrl(urlAddress, body: body);
  }

  /// Add service to remote DB.
  ///
  /// Create request body and call [_commitUrl].
  Future<ServiceState?> _commitAdd(
    ServiceOfJournal serv, {
    String? body,
  }) async {
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

    return _commitUrl(urlAddress, body: body);
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
  /// {@category Client-Server API}
  Future<ServiceState?> _commitUrl(String urlAddress, {String? body}) async {
    final url = Uri.parse(urlAddress);
    final http = workerProfile.ref
        .read(httpClientProvider(workerProfile.key.certificate));
    var ret = ServiceState.added;
    final fullHeaders = {'api_key': apiKey}..addAll(httpHeaders);
    try {
      Response response;

      if (urlAddress.endsWith('/add')) {
        response = await http.post(url, headers: fullHeaders, body: body);
      } else if (urlAddress.endsWith('/delete')) {
        response = await http.delete(url, headers: fullHeaders, body: body);
      } else {
        response = await http.get(url, headers: fullHeaders);
      }
      log.info(
        '$url response.statusCode = ${response.statusCode}\n\n '
        '${response.body}',
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
      showErrorNotification(tr().sslError);
      log.severe('Server HandshakeException error $url ');
    } on ClientException {
      showErrorNotification(tr().serverError);
      log.severe('Server error  $url  ');
    } on SocketException {
      showErrorNotification(tr().internetError);
      log.warning('No internet connection $url ');
    } on HttpException {
      showErrorNotification(tr().httpAccessError);
      log.severe('Server access error $url ');
    } finally {
      log.fine('sync ended $url ');
    }

    return ret;
  }

  /// Try to commit all [servicesForSync].
  ///
  /// It works via [_commitAdd],
  /// it change state of services.
  Future<void> commitAll() async {
    //
    // > main loop, synchronized
    //
    await _lock.synchronized(() async {
      await Future.wait(
        servicesForSync.map((serv) async {
          try {
            switch (await _commitAdd(serv)) {
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
              case null:
                log.fine('commit stub');
            }
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            log.severe('Sync services: $e');
          }
        }),
      );
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
      await _commitDel(serv);
    }
    //
    // delete
    //
    try {
      await servicesProvider.delete(serv);
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
  /// Only hiveArchiveLimit number of services could be stored in archive,
  /// most old will be deleted first.
  Future<void> archiveOldServices() async {
    //
    // > open hive archive and add old services
    //
    await ref.read(hiveJournalBox('journal_archive_$apiKey').future);
    hiveArchive = ref.read(hiveJournalBox('journal_archive_$apiKey')).value!;
    final forDelete = _forArchive.toList(); // don't lose this list after delete
    final forArchive = forDelete.map((e) => e.copyWith());
    if (forArchive.isNotEmpty) {
      await hiveArchive.addAll(forArchive); // check duplicates error
      //
      // > delete finished old services and save hive
      //
      toDelete(forDelete);
      //
      // > keep only [archiveLimit] number of services, delete oldest and close
      //
      // todo: check if hiveArch always place new services last,
      //  in that case we can just use deleteAt()
      final archList = hiveArchive.values.toList()
        ..sort((a, b) => a.provDate.compareTo(b.provDate))
        ..reversed;
      final archiveLimit = ref.read(hiveArchiveLimit);
      if (hiveArchive.length > archiveLimit) {
        await hiveArchive.deleteAll(
          archList.slice(archiveLimit).map<dynamic>((e) => e.key),
        );
      }
      await hiveArchive.compact();
      //
      // > update datesInArchive
      //
      await updateDatesInArchiveOfProfile();
    } else if (ref.read(datesInArchiveOfProfile(apiKey)).isEmpty) {
      await updateDatesInArchiveOfProfile();
    }
  }

  Future<void> updateDatesInArchiveOfProfile() async {
    await ref.read(hiveJournalBox('journal_archive_$apiKey').future);
    final hiveArchive =
        ref.read(hiveJournalBox('journal_archive_$apiKey')).value!;
    ref.read(datesInArchiveOfProfile(apiKey).notifier).state = hiveArchive
        .values
        .map((element) => element.provDate)
        .map((e) => DateTime(e.year, e.month, e.day))
        .toList();
    await ref.read(datesInArchiveOfProfile(apiKey).notifier).save();
  }

  /// Helper, only used in [ClientService], it delete last [ServiceOfJournal].
  ///
  /// Note: it delete services in this order:
  /// - rejected,
  /// - stalled,
  /// - finished,
  /// - outdated.
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
  /// after [WorkerProfile.clientPlan] synchronized.
  Future<void> updateBasedOnNewPlanDate() async {
    await _lock.synchronized(() async {
      // work with copy
      finished.toList().forEach(
        (element) async {
          if (element.provDate.isBefore(
            workerProfile.ref.read(planOfWorkerSyncDate(workerProfile)),
          )) {
            toOutDated(element);
          }
        },
      );
    });
  }

  /// Remove [ServiceOfJournal] from lists of [Journal] and from Hive.
  void toDelete(List<ServiceOfJournal> forDelete) {
    forDelete.forEach((s) {
      servicesProvider.delete(s);
      s.delete();
    });
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
    servicesProvider.delete(service);
    //
    // > add
    //
    final newService = service.copyWith(state: newState);
    servicesProvider.post(newService);

    return newService;
  }
}
