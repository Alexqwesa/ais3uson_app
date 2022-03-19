import 'dart:async';
import 'dart:developer' as dev;

import 'package:ais3uson_app/app_root.dart';
import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';

final locator = GetIt.instance;
final log = Logger('MyClassName');

Future<void> init({String hiveFolder = 'Ais3uson'}) async {
  // if (kDebugMode){
  //
  // > logger
  //
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    dev.log(
      '${record.level.name.substring(0, 3)}:  ${record.message}', //${record.time}:
    );
  });
  //
  // > hive adapter
  //
  try {
    // never fail on double adapter registration
    Hive
      ..registerAdapter(ServiceOfJournalAdapter())
      ..registerAdapter(ServiceStateAdapter());
    // ignore: avoid_catching_errors
  } on HiveError catch (e) {
    dev.log(e.toString());
  }
  //
  // > hive init
  //
  await Hive.initFlutter(hiveFolder);
  //
  // > locator
  //
  try {
    locator
      ..registerLazySingleton<S>(() => S())
      ..registerLazySingleton<AppData>(() => AppData());
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    dev.log(e.toString());
  }
}

/// Init application,init [Hive], create [AppData] and postInit it.
///
/// Create [OverlaySupport] and call [AppRoot].
///
/// {@category Root}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  unawaited(locator<AppData>().postInit());
  runApp(const OverlaySupport.global(child: AppRoot()));
}
