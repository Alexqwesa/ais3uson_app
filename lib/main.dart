import 'package:ais3uson_app/app_root.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/journal/journal.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

/// Init Hive and AppData
///
/// here is pre init staffs of the app
Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive
    ..registerAdapter(ServiceOfJournalAdapter())
    ..registerAdapter(ServiceStateAdapter());
  // await Hive.openBox('settings');
  final hivData = await Hive.openBox<dynamic>('profiles');
  final aData = AppData()..hiveData = hivData;
  await aData.postInit();

  return aData;
}

/// main
///
/// call preinit, overlay and app
Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(const OverlaySupport.global(child: AppRoot()));
}
