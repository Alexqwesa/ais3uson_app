/// # Providers of App
///
/// Top level providers of the application, they provide the entry points for UI components.
///
/// [workerProfiles] - Store List of [WorkerProfile]s
///
/// [isArchive] - Show archive date or today's data(helper [archiveDate] let select the date).
///
/// [lastUsed] - Store last used instance of classes:
///  - worker - [WorkerProfile],
///  - client - [ClientProfile],
///  - service - [ClientService].
///
/// [lastUsed] - is essential for navigation between screens.
///
library providers;

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/providers.dart';

export 'package:ais3uson_app/src/providers/provider_of_app_state.dart';
export 'package:ais3uson_app/src/providers/provider_of_journal.dart';
export 'package:ais3uson_app/src/providers/provider_of_list_of_profiles.dart';
