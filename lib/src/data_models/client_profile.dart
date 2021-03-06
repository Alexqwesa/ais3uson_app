import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:flutter/material.dart';

/// Model with data about client:
/// - [name],
/// - [contractId],
/// - [services] - list of [ClientService],
/// - reference to worker (of type [WorkerProfile]) assigned to this client.
///
/// {@category Data Models}
@immutable
class ClientProfile {
  /// Init and subscribe to events from [WorkerProfile],
  /// because it is the class that get actual data.
  const ClientProfile({
    required this.workerProfile,
    required this.entry,
  });

  final WorkerProfile workerProfile;
  final ClientEntry entry;

  int get contractId => entry.contractId;

  String get name => entry.client;

  String get contract => entry.contract;

  /// Return List of [ClientService]s (only for tests).
  List<ClientService> get services =>
      workerProfile.ref.read(servicesOfClient(this));
}
