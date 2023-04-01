/// # Data Models
///
/// These classes provide data for UI classes.
///
/// Dependency hierarchy:
///
/// - provider [workerProfiles] store list of:
///   - [WorkerProfile]s with different:
///     - [ClientProfile]s with different:
///       - [ClientService]s with different:
///         - [ServiceOfJournal]s with different:
///           - [Proofs]s.
///
/// **Notes:**
/// [Proofs] is actually intentionally not depend on [ServiceOfJournal] to allow:
///
/// - make one proof for several [ServiceOfJournal],
/// - to leave proof even in case of deleting of [ServiceOfJournal].
///
/// Also [ServiceOfJournal] managed separately by the class [Journal], that is part of [WorkerProfile].
///
/// The [WorkerProfile], [ClientProfile], [ClientService] classes provide data that they got from classes in
/// category [Client-Server API](https://alexqwesa.github.io/ais3uson_app/client_server_api/client_server_api-library.html).
///
/// The [Proofs] class collect data from filesystem and make lists of [ProofEntry]s.
/// It also has methods for creating new [ProofEntry]s.
library data_models;

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';

export 'package:ais3uson_app/src/data_models/client_profile.dart';
export 'package:ais3uson_app/src/data_models/client_service/client_service.dart';
export 'package:ais3uson_app/src/data_models/client_service/repository_of_client_service.dart';
export 'package:ais3uson_app/src/data_models/controller_of_worker_profiles.dart';
export 'package:ais3uson_app/src/data_models/proofs/controller_groups_of_proof.dart';
export 'package:ais3uson_app/src/data_models/proofs/controller_of_proof_recorder.dart';
export 'package:ais3uson_app/src/data_models/proofs/proofs.dart';
export 'package:ais3uson_app/src/data_models/proofs/provider_of_audioplayer.dart';
export 'package:ais3uson_app/src/data_models/proofs/recorder_state.dart';
export 'package:ais3uson_app/src/data_models/providers_for_worker_profile.dart';
export 'package:ais3uson_app/src/data_models/services_of_client.dart';
export 'package:ais3uson_app/src/data_models/worker_profile.dart';
