import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client_profile.g.dart';

/// Extension of [ClientProfile] with providers:
/// [servicesOf] - provider of list of [ClientService].
///
/// {@category Data Models Logic}
@Riverpod(keepAlive: true)
class ClientProfile extends _$ClientProfile {
  @override
  ClientEntry build({required String apiKey, required ClientEntry entry}) {
    return entry;
  }

  // get workerProfile => ref.watch(state.);
  // ClientEntry get ClientEntry => state;

  int get contractId => state.contractId;

  String get name => state.client;

  String get contract => state.contract;

  Worker get workerProfile => ref.read(workerByApiProvider(apiKey));

  List<ClientService> get services => ref.watch(servicesOfClient(this));

  Provider<List<ServiceOfJournal>> get allServicesOf =>
      allServicesOfClient(this);

  Provider<List<ClientService>> get servicesOf => servicesOfClient(this);
}

/// Provider of list of [ClientService]s for client.
///
/// {@category Providers}
final servicesOfClient =
    Provider.family<List<ClientService>, ClientProfile>((ref, client) {
  final listPlanned = ref
      .watch(client.workerProfile.clientsPlanOf)
      .where((e) => e.contractId == client.contractId);
  final acceptId = listPlanned.map((e) => e.servId).toSet();

  return ref
      .watch(client.workerProfile.servicesOf)
      .where((service) => acceptId.contains(service.id))
      .map(
        (e) => ClientService(
          workerProfile: client.workerProfile,
          service: e,
          planned: listPlanned.firstWhere((element) => element.servId == e.id),
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
  final journal = client.workerProfile.journal;
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
  final services = ref.watch(wp.journalAllOf.servicesOf);

  return services
      .where((element) => element.contractId == client.contractId)
      .toList();
});
