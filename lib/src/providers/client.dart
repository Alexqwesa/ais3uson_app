import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client.g.dart';

/// Provider of [ClientState], which store List<[ClientService]> and [ClientEntry].
///
/// {@category Data Models Logic}
@Riverpod(keepAlive: true)
class Client extends _$Client {
  @override
  ClientState build({required String apiKey, required ClientEntry entry}) {
    // final services = ref.watch(workerProvider(apiKey).select(
    //   (workerState) {
    //     final listPlanned =
    //         workerState.planned.where((e) => e.contractId == entry.contractId);
    //     final acceptId = listPlanned.map((e) => e.servId).toSet();
    //     return workerState.services
    //         .where((service) {
    //           if (acceptId.contains(service.id)) {
    //             return true;
    //           } else {
    //             return false;
    //             // todo: also add services not in list as stub readOnly, or throw error, or send error to administrator
    //           }
    //         })
    //         .map((entry) => ClientService(
    //               ref: ref,
    //               apiKey: apiKey,
    //               service: entry,
    //               planned: listPlanned
    //                   .firstWhere((element) => element.servId == entry.id),
    //             ))
    //         .toList(growable: false)
    //       ..sort((a, b) => a.servId.compareTo(b.servId)); // preserve id order
    //   },
    // ));
    final workerState = ref.watch(workerProvider(apiKey));

    final listPlanned =
        workerState.planned.where((e) => e.contractId == entry.contractId);
    final acceptId = listPlanned.map((e) => e.servId).toSet();
    final services = workerState.services
        .where((service) {
          if (acceptId.contains(service.id)) {
            return true;
          } else {
            return false;
            // todo: also add services not in list as stub readOnly, or throw error, or send error to administrator
          }
        })
        .map((entry) => ClientService(
              ref: ref,
              apiKey: apiKey,
              service: entry,
              planned: listPlanned
                  .firstWhere((element) => element.servId == entry.id),
            ))
        .toList(growable: false)
      ..sort((a, b) => a.servId.compareTo(b.servId)); // preserve id order

    return ClientState(
        ref: ref,
        apiKey: apiKey,
        entry: entry,
        services: services,
        state: ref.watch(appStateProvider),
        worker: ref.read(workerProvider(apiKey).notifier));
  }

  // get worker => ref.watch(state.);
  // ClientEntry get ClientEntry => state;

  int get contractId => state.entry.contractId;

  String get name => state.entry.client;

  String get contract => state.entry.contract;

  Worker get worker =>
      state.worker; //ref.watch(workerProvider(apiKey).notifier);

  List<ClientService> get services => state.services;

  Provider<List<ServiceOfJournal>> get allServicesOf =>
      allServicesOfClient(this);

// Provider<List<ClientService>> get servicesOf => servicesOfClient(this);
}

class ClientState {
  final Ref ref;

  final String apiKey;

  final ClientEntry entry;

  final List<ClientService> services;

  final AppState state;

  final Worker worker;

  ClientState({
    required this.ref,
    required this.apiKey,
    required this.entry,
    required this.services,
    required this.state,
    required this.worker,
  });
}

/// Today + archived [ServiceOfJournal] of client.
///
/// {@category Providers}
final allServicesOfClient =
    Provider.family<List<ServiceOfJournal>, Client>((ref, client) {
  final journal = client.worker.journal;

  return [
    ...ref.watch(_archiveOfClient(client)),
    ...ref
        .watch(journal.servicesOf)
        .where((element) => element.contractId == client.contractId),
  ];
});

/// Helper for provider [allServicesOfClient].
final _archiveOfClient =
    Provider.family<List<ServiceOfJournal>, Client>((ref, client) {
  ref.watch(
      hiveJournalBox(client.worker.journal.hiveRepository.journalHiveName));
  final wp = client.worker;
  final services = ref.watch(wp.journalAllOf.servicesOf);

  return services
      .where((element) => element.contractId == client.contractId)
      .toList();
});
