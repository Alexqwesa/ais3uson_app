import 'package:ais3uson_app/source/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AppData.instance,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Настройки:'),
        ),
        // body: ListView(),
        body: const Center(
          child: Text('Здесь будут настройки приложения:'),
        ),
      ),
    );
  }
}
