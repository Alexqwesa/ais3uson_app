/// # Providers of App
///
/// Top level providers of the application, they provide the entry points for UI components.
///
/// [departmentsProvider] - Store List of [Worker]s
///
/// [isArchiveProvider] - Show archive date or today's data(helper [archiveDate] let select the date).
///
library providers;

import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/data_models_with_logic/worker.dart';

export 'package:ais3uson_app/src/journal/journals_provider.dart';
export 'package:ais3uson_app/src/providers/app_provider_observer.dart';
export 'package:ais3uson_app/src/providers/departments.dart';
export 'package:ais3uson_app/src/providers/player_and_recorder_of_proof/audioplayer.dart';
export 'package:ais3uson_app/src/providers/player_and_recorder_of_proof/recorder.dart';
export 'package:ais3uson_app/src/providers/player_and_recorder_of_proof/recorder_state.dart';
export 'package:ais3uson_app/src/providers/is_archive_provider.dart';
export 'package:ais3uson_app/src/providers/stub_providers.dart';
