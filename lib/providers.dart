/// # Providers of App
///
/// Top level providers of the application, they provide the entry points for UI components.
///
/// [departmentsProvider] - Store List of [WorkerProfile]s
///
/// [isArchive] - Show archive date or today's data(helper [archiveDate] let select the date).
///
library providers;

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/providers.dart';

export 'package:ais3uson_app/src/providers/app_provider_observer.dart';
export 'package:ais3uson_app/src/providers/departments.dart';
export 'package:ais3uson_app/src/providers/player_and_recorder_of_proof/audioplayer.dart';
export 'package:ais3uson_app/src/providers/player_and_recorder_of_proof/recorder.dart';
export 'package:ais3uson_app/src/providers/player_and_recorder_of_proof/recorder_state.dart';
export 'package:ais3uson_app/src/providers/provider_of_app_state.dart';
export 'package:ais3uson_app/src/providers/provider_of_journal.dart';
