/// # Low level data management.
///
/// These provider are used then application want to access `Http`, [Hive] or [SharedPreferences].
library access_to_io;

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:ais3uson_app/src/access_to_io//access_hive.dart';
export 'package:ais3uson_app/src/access_to_io/access_http.dart';
export 'package:ais3uson_app/src/access_to_io/access_http_image.dart';
export 'package:ais3uson_app/src/access_to_io/access_shared_preferences.dart';
