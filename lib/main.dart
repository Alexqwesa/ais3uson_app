import 'package:ais3uson_app/src/gui/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/global.dart';

/// Init Hive and AppData
///
/// here is pre init staffs of the app
Future<void> init() async {
  await Hive.initFlutter();
  // await Hive.openBox('settings');
  Box hivData = await Hive.openBox('data');
  AppData aData = AppData();
  aData.hiveData = hivData;
  aData.postInit();
}

/// main
void main() async {
  await init();
  runApp(const MyApp());
}
