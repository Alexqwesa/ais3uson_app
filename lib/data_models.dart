/// # Data Models
///
/// These classes provide data for UI classes.
///
/// Hierarchy of classes:
///
/// - provider [workerProfiles] store list of:
///   - [WorkerProfile]s with different:
///     - [ClientProfile]s with different:
///       - [ClientService]s with different:
///         - [currentService] provider witch overridden(optional), with different:
///           - [ServiceOfJournal]s (with different date),
///             - [Proofs]s.
///
/// Note: [Proofs] is intentionally not depend on [ServiceOfJournal] to allow:
///
/// - make one proof for several [ServiceOfJournal],
/// - to leave proof even in case of deleting of [ServiceOfJournal].
///
/// [WorkerProfile], [ClientProfile], [ClientService] classes provide data that they got from classes in
/// category [Client-Server API].
///
/// [Proofs] class collect data from filesystem and make lists of [ProofEntry]s. It also has methods
/// for creating new [ProofEntry]s.
library data_models;

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';

export 'package:ais3uson_app/src/data_models/client_profile.dart';
export 'package:ais3uson_app/src/data_models/client_service/client_service.dart';
export 'package:ais3uson_app/src/data_models/client_service/repository_of_client_service.dart';
export 'package:ais3uson_app/src/data_models/controller_of_worker_profiles_list.dart';
export 'package:ais3uson_app/src/data_models/proofs/proofs.dart';
export 'package:ais3uson_app/src/data_models/proofs/provider_of_audioplayer.dart';
export 'package:ais3uson_app/src/data_models/proofs/provider_of_recorder.dart';
export 'package:ais3uson_app/src/data_models/proofs/repository_of_prooflist.dart';
export 'package:ais3uson_app/src/data_models/repository_of_client_profile.dart';
export 'package:ais3uson_app/src/data_models/repository_of_worker.dart';
export 'package:ais3uson_app/src/data_models/worker_profile.dart';
