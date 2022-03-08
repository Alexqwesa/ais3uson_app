import 'dart:async';
import 'dart:developer' as dev;

import 'package:ais3uson_app/app_root.dart';
import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:singleton/singleton.dart';

final locator = GetIt.instance;
final log = Logger('MyClassName');

/// Init application,init [Hive], create [AppData] and postInit it.
///
/// Create [OverlaySupport] and call [AppRoot].
///
/// {@category Root}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (kDebugMode){
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    dev.log(
      '${record.level.name.substring(0, 3)}:  ${record.message}', //${record.time}:
    );
  });
  await Hive.initFlutter('Ais3uson');
  Singleton.register(AppData);
  locator.registerLazySingleton<S>(() => S());

  unawaited(AppData().postInit());
  runApp(const OverlaySupport.global(child: AppRoot()));
}
