/// # These classes provide data for UI classes.
///
/// This is a library of `Data Models` extended by providers to access dynamic data.
///
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
/// Actually, [Proofs] is intentionally not depend on [ServiceOfJournal] to allow:
///
/// - make one proof for several [ServiceOfJournal],
/// - to leave proof even in case of deleting of [ServiceOfJournal].
///
/// Also [ServiceOfJournal] managed separately by the class [Journal], that is part of [WorkerProfile].
///
/// The [Proofs] class collect data from filesystem and make lists of [ProofEntry]s.
/// It also has methods for creating new [ProofEntry]s.
library dynamic_data_models;

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';

export 'package:ais3uson_app/data_models.dart';
export 'package:ais3uson_app/src/data_models_with_logic/client_profile_logic.dart';
export 'package:ais3uson_app/src/data_models_with_logic/client_service_logic.dart';
export 'package:ais3uson_app/src/data_models_with_logic/worker_profile_logic.dart';
