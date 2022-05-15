import 'package:ais3uson_app/source/client_server_api/client_plan.dart';
import 'package:ais3uson_app/source/client_server_api/service_entry.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:ais3uson_app/source/providers/providers_of_app_state.dart';
import 'package:ais3uson_app/source/ui/service_related/service_card.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_service_at.freezed.dart';

/// Model for [ServiceCard] .
///
/// This is mostly a view model for data from:
/// - [Journal],
/// - [ServiceEntry],
/// - [ClientPlan]...
///
/// {@category Data Models}
@freezed
class ClientServiceAt with _$ClientServiceAt, ClientServiceMixin {
  const factory ClientServiceAt({
    /// Reference to existing [WorkerProfile].
    required ClientService clientService,

    /// Null - for dynamic date (from provider [archiveDate])
    @override DateTime? date,
  }) = _ClientServiceAt;

  const ClientServiceAt._();

  @override
  ClientService? get thisClientService => clientService;

  /// Reference to existing [WorkerProfile] of [ClientService].
  @override
  WorkerProfile get workerProfile => clientService.workerProfile;

  /// Reference to existing [ServiceEntry] of [ClientService].
  @override
  ServiceEntry get service => clientService.service;

  /// Reference to existing [ClientPlan] of [ClientService].
  @override
  ClientPlan get planned => clientService.planned;

// /// Null - for dynamic date (from provider [archiveDate])
// DateTime? get date => throw UnsupportedError('Called stub!');
}
