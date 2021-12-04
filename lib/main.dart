import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/screens/home.dart';

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
