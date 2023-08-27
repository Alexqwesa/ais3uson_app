import 'dart:io';

import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:share_plus/share_plus.dart';
import 'package:synchronized/synchronized.dart';
import 'package:universal_html/html.dart' as html;

/// Journal of services.
///
/// The [Journal] class is a member of [Worker],
/// it manage worker's input([ServiceOfJournal]),
/// and provides access to them via lists of services [ServiceOfJournal].
///
/// The purpose of the [Journal] class is to:
///
/// - store services in Hive(via [hiveRepository]),
/// - make network requests(add/delete via [httpInterface]),
/// - change state of [ServiceOfJournal],
/// - move old `finished` and `outDated` services into [JournalArchive],
/// - export services into file.ais_json.
///
/// The [JournalArchive] class is a cut version of [Journal],
/// it store old `finished` and `outDated services.
///
/// Each instance of [Worker] can access [Journal] classes via providers:
///
/// - [Worker.journalOf],
/// - [Worker.journalAtDateOf].
///
/// [ClientProfile] can access both `Journal` classes at once via [allServicesOfClient].
///
/// ![Mind map of it functionality](https://raw.githubusercontent.com/Alexqwesa/ais3uson_app/master/lib/src/journal/journal.png)
///
/// {@category Journal}
/// {@category Client-Server API}
// ignore: prefer_mixin
class Journal extends BaseJournal {
  Journal(super.workerProfile, this.state);

  final AppState state;

  final _lock = Lock();

  Box<ServiceOfJournal> get hive =>
      hiveRepository.openHive.requireValue; // only for test

  Ref get ref => workerProfile.ref;

  HiveRepository get hiveRepository => workerProfile.hiveRepository;

  JournalHttpInterface get httpInterface => workerProfile.http;

  HiveRepositoryProvider get servicesOf => hiveRepositoryProvider(apiKey);

  //
  // > main list of services
  //

  List<ServiceOfJournal> get all => ref.read(servicesOf);

  // Todo: use providers here
  List<ServiceOfJournal> get added =>
      ref.watch(servicesOfJournalProvider(this))[ServiceState.added] ?? [];

  List<ServiceOfJournal> get finished =>
      ref.watch(servicesOfJournalProvider(this))[ServiceState.finished] ?? [];

  List<ServiceOfJournal> get outDated =>
      ref.watch(servicesOfJournalProvider(this))[ServiceState.outDated] ?? [];

  List<ServiceOfJournal> get rejected =>
      ref.watch(servicesOfJournalProvider(this))[ServiceState.rejected] ?? [];

  List<ServiceOfJournal> get servicesForSync => added;

  Iterable<ServiceOfJournal> get _forArchive =>
      (finished + outDated).where((el) => el.provDate.isBefore(today));

  String get journalHiveName => hiveRepository.journalHiveName;

  Future<void> exportToFile(DateTime start, DateTime end) async {
    final content = await hiveRepository.export(start, end);
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
          await Share.shareXFiles([XFile(filePath)]);
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

  /// This function move old finished(and outDated) services to `hiveArchive`.
  ///
  /// There are two reason to archive services,
  /// first - we want active hiveBox small and fast on all devices,
  /// second - we want worker to only see today's services, and
  /// services which didn't committed yet(stale/rejected).
  ///
  /// Archive is only for committed services.
  /// Only hiveArchiveLimit number of services could be stored in archive,
  /// the oldest services will be deleted first.
  @override
  Future<void> archiveOldServices() async {
    final forDelete = _forArchive.toList();
    if (forDelete.isNotEmpty) {
      final res = await hiveRepository.archiveOldServices(forDelete);
      //
      // > delete finished old services and save hive
      //
      _deleteFromHive(forDelete);

      return res;
    }
  }

  /// Add new [ServiceOfJournal] to [Journal] and call [commitAll].
  @override
  Future<bool> post(ServiceOfJournal se) async {
    try {
      await hiveRepository.add(se);
      // ignore: avoid_catching_errors, avoid_catches_without_on_clauses
    } catch (e) {
      showErrorNotification(tr().errorSave);
      await commitAll(); // still call?

      return false;
    }
    await commitAll();

    return true;
  }

  /// Try to commit all [servicesForSync].
  ///
  /// it change state of services.
  @override
  Future<void> commitAll() async {
    //
    // > main loop, synchronized
    //
    await _lock.synchronized(() async {
      await Future.wait(
        servicesForSync.map((serv) async {
          ServiceState? state;
          var error = '';
          try {
            (state, error) = await httpInterface.sendAdd(serv);
            switch (state) {
              case ServiceState.added: // no changes - do nothing
                log.info('stale service $serv');
              case ServiceState.finished:
                log.finest('finished service $serv');
                _toFinished(serv);
              case ServiceState.rejected:
                log.warning('rejected service $serv');
                _toRejected(serv);
              case ServiceState.outDated:
                throw StateError('commit can not make service outDated');
              case null:
                log.fine('commit stub');
              case ServiceState.removed:
                log.fine('removed service $serv');
            }
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            log.severe('Sync services failed: $e');
          }
          if (error.isNotEmpty) showErrorNotification(error);
        }),
      );
    });
  }

  /// Delete service [serv] (or find serv by [uuid]) from journal.
  ///
  /// Also notify listeners and save.
  /// Note: since services are deleted by uuid double deletes is not a problem.
  /// (Async lock is not needed.)
  @override
  Future<bool> delete({ServiceOfJournal? serv, String? uuid}) async {
    //
    // find service
    //
    serv ??= all.firstWhereOrNull((element) => element.uid == uuid);
    if (serv == null) {
      log.severe('Error: delete: not found by uuid');

      return false;
    }
    //
    // delete from DB if needed
    //
    var allowDelete = false;
    if ([ServiceState.finished, ServiceState.outDated].contains(serv.state)) {
      final (state, _) = await httpInterface.sendDelete(serv);
      if (state == ServiceState.removed) {
        allowDelete = true;
      }
    } else {
      allowDelete = true;
    }
    //
    // delete
    //
    if (allowDelete) {
      try {
        await hiveRepository.delete(serv);
        // ignore: avoid_catching_errors
      } on RangeError {
        log.info('RangeError double delete of service');
      }
    }
    return allowDelete;
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
  /// after [Worker.clientsPlanOf] synchronized.
  // TODO: delete it
  @override
  Future<void> updateBasedOnNewPlanDate() async {
    await _lock.synchronized(() async {
      // work with copy
      finished.toList().forEach(
        (element) {
          if (element.provDate.isBefore(
            workerProfile.planSyncDateOf,
          )) {
            _toOutDated(element);
          }
        },
      );
    });
  }

  /// Remove [ServiceOfJournal] from lists of [Journal] and from Hive.
  void _deleteFromHive(List<ServiceOfJournal> forDelete) {
    forDelete.forEach((s) async {
      await hiveRepository.delete(s);
    });
  }

  /// Shortcut for [_moveToNewState].
  ServiceOfJournal _toOutDated(ServiceOfJournal service) =>
      _moveToNewState(service, ServiceState.outDated);

  /// Shortcut for [_moveToNewState].
  ServiceOfJournal _toRejected(ServiceOfJournal service) =>
      _moveToNewState(service, ServiceState.rejected);

  /// Shortcut for [_moveToNewState].
  ServiceOfJournal _toFinished(ServiceOfJournal service) =>
      _moveToNewState(service, ServiceState.finished);

  /// Move service - create new in dst, delete old in src list of [Journal].
  ///
  /// Take care of [Journal] lists and Hive.
  ServiceOfJournal _moveToNewState(
    ServiceOfJournal service,
    ServiceState newState,
  ) {
    //
    // > remove
    //
    hiveRepository.delete(service);
    //
    // > add
    //
    final newService = service.copyWith(state: newState);
    hiveRepository.add(newService);

    return newService;
  }
}
