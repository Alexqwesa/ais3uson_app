/// These classes provide data for UI classes.
///
/// # Top level providers:
///
/// Provide the entry points for UI components.
///
/// [workerKeysProvider] - Store List of [Worker]s
///
/// [appStateProvider] - Store the inner state of App:
///  - isArchvie,
///  - atDate - show archive date,
///  - showAll - for archive view (show all dates).
///
/// # Dependency hierarchy:
///
/// - provider [workerKeysProvider] store list of [WorkerKey]s and provide access to [Worker]s:
///   - [Worker]s with different:
///     - [Client]s with different:
///       - [ClientService]s with different:
///         - [ServiceOfJournal]s with different:
///           - [ProofList]s.
///
/// **Notes:**
/// Actually, [ProofList] is intentionally not depend on [ServiceOfJournal] to allow:
///
/// - make one proof for several [ServiceOfJournal],
/// - to leave proof even in case of deleting of [ServiceOfJournal].
///
/// Also [ServiceOfJournal] managed separately by the class [Journal], that is part of [Worker].
///
/// The [ProofList] class collect data from filesystem and make lists of [Proof]s.
/// It also has methods for creating new [Proof]s.
library providers;

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';

export 'package:ais3uson_app/data_models.dart';
export 'package:ais3uson_app/src/journal/providers/journal_provider.dart';

// export 'package:ais3uson_app/src/proofs/player_and_recorder/audioplayer.dart';
// export 'package:ais3uson_app/src/proofs/player_and_recorder/recorder.dart';
// export 'package:ais3uson_app/src/proofs/player_and_recorder/recorder_state.dart';
export 'package:ais3uson_app/src/proofs/proof_list.dart';
export 'package:ais3uson_app/src/providers/app_provider_observer.dart';
export 'package:ais3uson_app/src/providers/client.dart';
export 'package:ais3uson_app/src/providers/client_service_state_provider.dart';
export 'package:ais3uson_app/src/providers/stub_providers.dart';
export 'package:ais3uson_app/src/providers/worker_provider.dart';
export 'package:ais3uson_app/src/services/app_state.dart';
export 'package:ais3uson_app/src/services/worker_keys.dart';
