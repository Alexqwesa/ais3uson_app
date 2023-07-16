import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Extension of [ClientProfile] with providers:
/// [servicesOf] - provider of list of [ClientService].
///
/// {@category Data Models Logic}
extension ClientProfileLogic on ClientProfile {
  List<ClientService> get services => workerProfile.ref.read(servicesOf);

  Provider<List<ServiceOfJournal>> get allServicesOf =>
      allServicesOfClient(this);

  Provider<List<ClientService>> get servicesOf => _servicesOfClient(this);
}

/// Provider of list of [ClientService]s for client.
///
/// {@category Providers}
final _servicesOfClient =
    Provider.family<List<ClientService>, ClientProfile>((ref, client) {
  final listServices = ref
      .watch(client.workerProfile.clientsPlanOf)
      .where((e) => e.contractId == client.contractId);
  final listServiceIds = listServices.map((e) => e.servId);

  return ref
      .watch(client.workerProfile.servicesOf)
      .where((e) => listServiceIds.contains(e.id))
      .map(
        (e) => ClientService(
          workerProfile: client.workerProfile,
          service: e,
          planned: listServices.firstWhere((element) => element.servId == e.id),
          // client: client,
        ),
      )
      .toList(growable: false)
    ..sort((a, b) => a.servId.compareTo(b.servId)); // preserve id order
});

/// Today + archived [ServiceOfJournal] of client.
///
/// {@category Providers}
final allServicesOfClient =
    Provider.family<List<ServiceOfJournal>, ClientProfile>((ref, client) {
  final journalProvider = client.workerProfile.journalProvider;
  final journal = ref.watch(journalProvider.realJournalOf);
  // ref.watch(
  //   groupsOfJournal(journal),
  // );

  return [
    ...ref.watch(_archiveOfClient(client)),
    ...ref
        .watch(journal.servicesOf)
        .where((element) => element.contractId == client.contractId),
  ];
});

/// Helper for provider [allServicesOfClient].
final _archiveOfClient =
    Provider.family<List<ServiceOfJournal>, ClientProfile>((ref, client) {
  ref.watch(hiveJournalBox(client.workerProfile.hiveName));
  final wp = client.workerProfile;
  final services = ref.watch(ref.watch(wp.journalAllOf).servicesOf);

  return services
      .where((element) => element.contractId == client.contractId)
      .toList();
});