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
/// First [repositoryHttp] get data from server and store it into hive
/// then it is converted to Json. Then it is converted to classes and assigned to providers of
/// [WorkerProfile].
///
/// Detailed API online at [https://alexqwesa.fvds.ru:48080/docs](https://alexqwesa.fvds.ru:48080/docs)
///  (usually it online `from 02:00 to 16:00 GMT` - didn't send it to cloud yet...) ,
///  test api-key is `3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c`
///
/// ## Output API
///
/// The methods for output are:
///
/// - [Journal.post] is used to send **/add** requests to server([AddClientServiceRequest]),
/// - [Journal.delete] is used to send **/delete** requests to server([DeleteClientServiceRequest]),
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
/// "api-key": "your real key will be here"
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
library api_classes;

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:ais3uson_app/src/api_classes/in/client_entry.dart';
export 'package:ais3uson_app/src/api_classes/in/client_plan.dart';
export 'package:ais3uson_app/src/api_classes/in/service_entry.dart';
export 'package:ais3uson_app/src/api_classes/inner/service_of_journal.dart';
export 'package:ais3uson_app/src/api_classes/out/add_client_service_request.dart';
export 'package:ais3uson_app/src/api_classes/out/delete_client_service_request.dart';
export 'package:ais3uson_app/src/api_classes/worker_key.dart';
