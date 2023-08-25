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

export 'package:ais3uson_app/src/journal/providers/journals_provider.dart';
export 'package:ais3uson_app/src/proofs/player_and_recorder/audioplayer.dart';
export 'package:ais3uson_app/src/proofs/player_and_recorder/recorder.dart';
export 'package:ais3uson_app/src/proofs/player_and_recorder/recorder_state.dart';
export 'package:ais3uson_app/src/proofs/proof_list.dart';
export 'package:ais3uson_app/src/providers/app_provider_observer.dart';
export 'package:ais3uson_app/src/providers/departments.dart';
export 'package:ais3uson_app/src/providers/is_archive_provider.dart';
export 'package:ais3uson_app/src/providers/stub_providers.dart';
