import 'package:hive_flutter/hive_flutter.dart';

import 'src/global.dart';

/// Init Hive and AppData
///
/// just all init staff of the app
Future<void> init() async {
  await Hive.initFlutter();
  // await Hive.openBox('settings');
  Box hivData = await Hive.openBox('data');
  AppData aData = AppData();
  aData.hiveData = hivData;
  aData.postInit();
}
