import 'dart:async';
import 'dart:developer' as dev;

import 'package:ais3uson_app/app_root.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// get_it locator
/// {@category UI Root}
final locator = GetIt.instance;

/// Translations strings getter.
///
/// tr = get_it locator<S>.
/// {@category UI Root}
final tr = locator<S>;

/// App Logger
/// {@category UI Root}
final log = Logger('MyClassName');

/// Main function for initializing whole App, also used in tests.
///
/// Init HiveAdapters, [locator] and [log].
///
/// {@category UI Root}
Future<void> init() async {
  // if (kDebugMode){
  //
  // > logger
  //
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    dev.log(
      '${record.level.name.substring(0, 3)}:  ${record.message}',
      //${record.time}:
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
  // > locator
  //
  final sharedPreferences = await SharedPreferences.getInstance();
  try {
    locator
      ..registerLazySingleton<S>(S.new)
      ..registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    dev.log(e.toString());
  }
}

/// Init application, init [Hive].
///
/// Create [OverlaySupport] and call [AppRoot].
///
/// {@category UI Root}
/// {@category About}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  //
  // > hive init
  //
  await Hive.initFlutter('Ais3uson');
  // unawaited(locator<AppData>().postInit());
  runApp(const OverlaySupport.global(child: ProviderScope(child: AppRoot())));
}
