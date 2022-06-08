import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${S.of(context).settings}:'),
      ),
      // body: ListView(),
      body: const Center(
        child: Text('Здесь будут настройки приложения:'),
      ),
    );
  }
}
