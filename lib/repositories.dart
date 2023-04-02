/// # Low level data management.
///
/// `Http`, [Hive], [SharedPreferences]
library Repositories;

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';


export 'package:ais3uson_app/src/data_repositories/repository_hive.dart';
export 'package:ais3uson_app/src/data_repositories/repository_http.dart';
export 'package:ais3uson_app/src/data_repositories/repository_http_image.dart';
export 'package:ais3uson_app/src/data_repositories/repository_shared_preferences.dart';