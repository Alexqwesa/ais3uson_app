/// # settings of application
///
/// Classes and providers that store configuration settings and related functions.
/// They mostly work through provider [preference] of [SharedPreferences].
///

library settings;

import 'package:ais3uson_app/access_to_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:ais3uson_app/src/providers/settings/hive_archive_size.dart';
export 'package:ais3uson_app/src/providers/settings/tile_magnification.dart';
export 'package:ais3uson_app/src/providers/settings/tile_size.dart';
export 'package:ais3uson_app/src/providers/settings/tile_type.dart';