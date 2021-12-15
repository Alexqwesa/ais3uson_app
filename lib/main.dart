import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Init Hive and AppData
///
/// here is pre init staffs of the app
Future init() async {
  await Hive.initFlutter();
  // await Hive.openBox('settings');
  final hivData = await Hive.openBox('data');
  final aData = AppData()
    ..hiveData = hivData
    ..postInit();

  return aData;
}

/// main
Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(const HomeScreen());
}
