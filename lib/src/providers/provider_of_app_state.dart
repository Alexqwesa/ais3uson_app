import 'dart:convert';

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/src/providers/departments.dart';
import 'package:ais3uson_app/src/stubs_for_testing/worker_keys_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_of_app_state.g.dart';

/// Stub provider of current service.
final currentService = Provider<ClientService>(
    (ref) => ref.read(stubClientServiceProvider), // TODO: maybe just throw
    dependencies: [currentClient]);

/// Stub provider of current service.
final currentClient = Provider<ClientProfile>(
  (ref) => ref.read(stubClientProvider), // TODO: maybe just throw
  dependencies: [departmentsProvider],
);

final _stubKey =
    WorkerKey.fromJson(jsonDecode(stubJsonWorkerKey) as Map<String, dynamic>);

@riverpod
Worker stubWorker(Ref ref) => ref.watch(workerProvider(_stubKey).notifier);

@riverpod
ClientProfile stubClient(Ref ref) => ref.watch(
      clientProfileProvider(
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

@riverpod
ClientService stubClientService(Ref ref) => ClientService(
      workerProfile: ref.read(stubWorkerProvider),
      service: const ServiceEntry(id: 0, serv_text: 'Error: Service not found'),
      planned:
          const ClientPlan(contract_id: 0, serv_id: 0, planned: 0, filled: 0),
    );

/// Provider of setting - archiveDate. Inited with null, doesn't save its value.
///
/// {@category Providers}
/// {@category App State}
final archiveDate = StateProvider<DateTime?>((ref) {
  return null;
});

/// Archive view or usual view of App.
///
/// {@category Providers}
/// {@category App State}
// Todo: only use archiveDate?
@Riverpod(keepAlive: true)
class IsArchive extends _$IsArchive {
  @override
  bool build() {
    return false;
  }

  @override
  set state(bool value) {
    super.state = value;
    if (!value) {
      ref.read(archiveDate.notifier).state = null;
    }
  }
}
