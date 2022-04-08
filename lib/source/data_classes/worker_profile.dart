// ignore_for_file: always_use_package_imports, flutter_style_todos

import 'dart:async';

import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/from_json/client_plan.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/journal/archive/journal_archive.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/providers/worker_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

/// A profile of worker.
///
/// {@category Data_Classes}
// ignore: prefer_mixin
class WorkerProfile {
  /// Constructor [WorkerProfile] with [Journal] by default
  /// or with [JournalArchive].
  ///
  /// TODO: finish detect SSL code
  WorkerProfile(this.key, this.ref, {DateTime? archiveDate}) {
    name = key.name;
    journal =
        archiveDate != null ? JournalArchive(this, archiveDate) : Journal(this);
    fullArchive = JournalArchive(this, null);
    // var httpClient = ref.read(httpClientProvider);
  }

  final WorkerKey key;
  late final Journal journal;
  late final JournalArchive fullArchive;
  late final String name;

  final ProviderContainer ref;

  String get apiKey => key.apiKey;

  String get urlClients => '${key.activeServer}/clients';

  String get urlPlan => '${key.activeServer}/planned';

  String get urlServices => '${key.activeServer}/services';

  List<ClientProfile> get clients => ref.read(clientsOfWorker(this));

  /// Planned amount of services for client.
  ///
  /// Since we get data in bunch - store it in [WorkerProfile].
  List<ClientPlan> get clientPlan => ref.read(planOfWorker(this));

  /// Service list should only update on empty, or unknown planned service.
  ///
  /// Since workers could potentially work
  /// on two different organizations (half rate in each),
  /// with different service list, store services in worker profile.
  // TODO: update by server policy.
  List<ServiceEntry> get services => ref.read(servicesOfWorker(this));

  void dispose() {
    journal.dispose();

    // return super.dispose();
  }

  WorkerProfile copyWith({DateTime? archiveDate}) {
    return WorkerProfile(key, ref, archiveDate: archiveDate);
  }

  /// Async init actions such as:
  ///
  /// - postInit [journal] (instance of [Journal] class),
  /// - read [clients], [clientPlan] and [services] from hive if empty,
  /// - check last sync dates and sync [clients], [clientPlan] and [services],
  /// - and call notifyListeners.
  Future<void> postInit() async {
    await journal.postInit();
    //
    // > sync data on load
    //
    await ref
        .read(httpDataProvider(Tuple2(apiKey, urlServices)).notifier)
        .syncHiveHttp();
    await ref
        .read(httpDataProvider(Tuple2(apiKey, urlClients)).notifier)
        .syncHiveHttp();
    await ref
        .read(httpDataProvider(Tuple2(apiKey, urlPlan)).notifier)
        .syncHiveHttp();
  }

  Future<void> syncHiveClients() async {
    // await ref.read(httpDataProvider([apiKey, urlClients]).notifier).state(
    //     (state){}()
    // );
    await ref
        .read(httpDataProvider(Tuple2(apiKey, urlClients)).notifier)
        .getHttpData();
  }

  Future<void> syncHivePlanned() async {
    await ref
        .read(httpDataProvider(Tuple2(apiKey, urlPlan)).notifier)
        .getHttpData();
  }

  /// Synchronize services for [WorkerProfile.services].
  ///
  /// TODO: Services usually updated once per year,
  /// and before calling this function
  /// we should check: is it really necessary, i.e. is [services] empty.
  ///
  /// This function also called from [checkAllServicesExist], if there is a
  /// [clientPlan] with wrong [ClientPlan.servId].
  Future<void> syncHiveServices() async {
    await ref
        .read(httpDataProvider(Tuple2(apiKey, urlServices)).notifier)
        .getHttpData();
  }

  /// This should only be called if there is inconsistency:
  ///
  /// [ClientPlan] had nonexist service Id. This can happen:
  /// - then list of [ServiceEntry] is reduced on server,
  /// - database has inconsistency. TODO: check it here - low priority.
  Future<void> checkAllServicesExist() async {
    return;
    //   if (_services.isEmpty) {
    //     await syncHiveServices();
    //   } else if (ref
    //       .read(servicesOfWorkerSyncDate(this))
    //       .isBefore(ref.read(planOfWorkerSyncDate(this)))) {
    //     await syncHiveServices();
    //   } else {
    //     // TODO: actual checks here
    //   }
  }
}
