import 'package:ais3uson_app/app_root.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:singleton/singleton.dart';

/// Init application,init [Hive], create [AppData] and postInit it.
///
/// Create [OverlaySupport] and call [AppRoot].
///
/// {@category Root}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Singleton.register(AppData);

  await AppData().postInit();
  runApp(const OverlaySupport.global(child: AppRoot()));
}
