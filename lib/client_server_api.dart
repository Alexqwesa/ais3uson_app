/// # Client-Server API
///
/// ## Input API
///
/// Classes like:
///
/// - [ClientEntry],
/// - [ClientPlan],
/// - [ServiceEntry],
///
/// are used to convert server responses from Json strings to dart classes.
/// Mostly freezed.
///
/// First [repositoryOfHttpData] get data
/// from server and convert to Json. Then it is converted to classes and assigned to providers of
/// family [WorkerProfile].
///
/// ## Output API
///
/// The methods for output are:
///
/// - [Journal.post] is used to send **/add** requests to server,
/// - [Journal.delete] is used to send **/delete** requests to server,
/// - [Journal.exportToFile] is used to save list of [ServiceOfJournal] to a file **.ais_json** .
///
/// These methods use json format.
///
/// #### Http headers
///
/// ```json
/// {
/// "Content-type": "application/json",
/// "Accept": "application/json",
/// "api_key": "your real key will be here"
/// }
/// ```
///
/// ## Storage API
///
/// Most data is stored in [Hive] Boxes. Http responses are stored as strings.
///
/// The settings and [WorkerKey]s are stored in [SharedPreferences].
///
/// The [ServiceOfJournal]s are stored in [Hive] as objects.
///
/// The [Proofs]s store files in filesystem.
library client_server_api;

import 'package:ais3uson_app/client_server_api.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:ais3uson_app/src/client_server_api/client_entry.dart';
export 'package:ais3uson_app/src/client_server_api/client_plan.dart';
export 'package:ais3uson_app/src/client_server_api/service_entry.dart';
export 'package:ais3uson_app/src/client_server_api/worker_key.dart';
