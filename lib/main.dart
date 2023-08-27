/// # The entry point for the application
///
/// Not a library, just a place to initialize some properties and plugins
/// of the application:
/// - tr  - translation provider,
/// - log - logger,
/// - set lets-encrypt certificate,
/// - register Hive adapters (and open [hiveHttpCache] Box)...
///

// ignore_for_file: unreachable_from_main

library main;

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:ais3uson_app/src/stubs_for_testing/default_data.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_strategy/url_strategy.dart';

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
final log = Logger('ais3uson');

/// Main function for initializing whole App, also used in tests.
///
/// Init HiveAdapters, [locator] and [log].
///
/// {@category UI Root}
Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ..registerAdapter(
        ServiceStateAdapter(),
      );
    // ignore: avoid_catching_errors
  } on HiveError catch (e) {
    log.severe(e.toString());
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

Future<void> main() async {
  await initAndSetCertificate();
  await runMain();
}

/// Should only called once, call [init] inside, and set certificate.
Future<void> initAndSetCertificate() async {
  //
  // > init for tests
  //
  await init();
  //
  // > add certificate
  //
  if (!kIsWeb) {
    final data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
}

/// Run application, init [Hive], set urlStrategy, and demo data.
///
/// Create [OverlaySupport] and call [AppRoot].
///
/// {@category UI Root}
/// {@category About}
Future<void> runMain() async {
  httpTestHeader = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'api-key': '3.01567984187____',
  };
  //
  // > hive init
  //
  await Hive.initFlutter('Ais3uson');
  final openHttpBox = await Hive.openBox(hiveHttpCache);

  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(OverlaySupport.global(
    child: ProviderScope(
      observers: [AppProviderObserver()],
      overrides: [
        hiveBox(hiveHttpCache).overrideWith((ref) => openHttpBox),
        // stub data for demo mode and testing
        httpClientProvider(testWorkerKey().certBase64)
            .overrideWithValue(getMockHttpClient()),
      ],
      child: const AppRoot(),
    ),
  ));
}
