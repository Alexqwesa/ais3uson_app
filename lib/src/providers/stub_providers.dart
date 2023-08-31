import 'dart:convert';

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_worker_keys_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stub_providers.g.dart';

/// Provider of current service - default is [stubClientServiceProvider], to be overridden.
final currentService =
    Provider<ClientService>((ref) => ref.read(stubClientServiceProvider),
        // TODO: handle loading nicer
        dependencies: [currentClient]);

/// Provider of current client - default is [stubClientProvider], to be overridden.
final currentClient = Provider<Client>(
  (ref) => ref.read(stubClientProvider), // TODO: handle loading nicer
  dependencies: const [workerProvider],
);

final stubWorkerKey =
    WorkerKey.fromJson(jsonDecode(stubJsonWorkerKey) as Map<String, dynamic>);

/// Stub provider of [Worker].
@riverpod
Worker stubWorker(Ref ref) =>
    ref.watch(workerProvider(stubWorkerKey.apiKey).notifier);

/// Stub provider of client.
@riverpod
Client stubClient(Ref ref) => ref.watch(
      clientProvider(
        apiKey: ref.read(stubWorkerProvider).apiKey,
        entry: const ClientEntry(
          contract_id: 0,
          dep_id: 0,
          client_id: 0,
          dhw_id: 0,
          comment: 'Error: Client not found',
        ),
      ).notifier,
    );

/// Stub provider of service.
@riverpod
ClientService stubClientService(Ref ref) => ClientService(
      ref: ref,
      apiKey: ref.read(stubWorkerProvider).apiKey,
      // worker: ref.read(stubWorkerProvider),
      service: const ServiceEntry(id: 0, serv_text: 'Error: Service not found'),
      planned:
          const ClientPlan(contract_id: 0, serv_id: 0, planned: 0, filled: 0),
    );
