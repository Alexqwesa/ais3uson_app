import 'dart:core';

import 'package:ais3uson_app/source/client_server_api/client_entry.dart';
import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/client_server_api/service_entry.dart';
import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/providers/repository_of_http_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Providers clients of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientProfile]>.
///
/// {@category Providers}
final clientsOfWorker = Provider.family<List<ClientProfile>, WorkerProfile>(
  (ref, wp) {
    ref.watch(httpDataProvider(wp.apiUrlClients).notifier).syncHiveHttp();

    return ref
        .watch(httpDataProvider(wp.apiUrlClients))
        .map<ClientEntry>(ClientEntry.fromJson)
        .map((el) => ClientProfile(workerProfile: wp, entry: el))
        .toList(growable: false);
  },
);

/// Providers services of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ServiceEntry]>.
///
/// {@category Providers}
final servicesOfWorker =
    Provider.family<List<ServiceEntry>, WorkerProfile>((ref, wp) {
  ref.watch(httpDataProvider(wp.apiUrlServices).notifier).syncHiveHttp();

  return ref
      .watch(httpDataProvider(wp.apiUrlServices))
      .map<ServiceEntry>(ServiceEntry.fromJson)
      .toList(growable: false);
});

/// Providers services of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
final planOfWorker =
    Provider.family<List<ClientPlan>, WorkerProfile>((ref, wp) {
  ref.watch(httpDataProvider(wp.apiUrlPlan).notifier).syncHiveHttp();

  return ref
      .watch(httpDataProvider(wp.apiUrlPlan))
      .map<ClientPlan>(ClientPlan.fromJson)
      .toList(growable: false);
});
