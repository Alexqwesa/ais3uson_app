import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/screens/home.dart';

/// Init Hive and AppData
///
/// here is pre init staffs of the app
Future init() async {
  await Hive.initFlutter();
  // await Hive.openBox('settings');
  Box hivData = await Hive.openBox('data');
  AppData aData = AppData();
  aData.hiveData = hivData;
  aData.postInit();
  return AppData();
}

/// main
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(HomeScreen());
}
