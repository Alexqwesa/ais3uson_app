import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/screens/home.dart';

import 'package:provider/provider.dart';

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

class ProviderApp extends StatelessWidget {
  final AppData data;

  ProviderApp({
    required this.data,
  });

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (BuildContext context) => AppData(),
        child: const HomeScreen(),
      );
}

/// main
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(ProviderApp(
    data: AppData(),
  ));
  // runApp(const MyApp());
}
