import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/journal.dart';
import 'package:ais3uson_app/src/screens/home_screen.dart';
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
Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(const OverlaySupport.global(child: HomeScreen()));
}
