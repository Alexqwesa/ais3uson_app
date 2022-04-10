import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/client_entry.dart';
import 'package:ais3uson_app/source/providers/repository_of_client.dart';

/// Basic data about client:
/// - [name],
/// - [contractId],
/// - [services] - list of [ClientService],
/// - reference to worker (of type [WorkerProfile]) assigned to this client.
///
/// {@category Data_Classes}
class ClientProfile {
  /// Init and subscribe to events from [WorkerProfile],
  /// because it is the class that get actual data.
  ClientProfile({
    required this.workerProfile,
    required this.entry,
  });

  final WorkerProfile workerProfile;
  final ClientEntry entry;

  int get contractId => entry.contractId;

  String get name => entry.client;

  String get contract => entry.contract;

  /// Return List of [ClientService]s.
  List<ClientService> get services =>
      workerProfile.ref.read(servicesOfClient(this));
}
