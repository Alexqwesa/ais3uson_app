import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/providers/providers_of_settings.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${S.of(context).settings}:'),
      ),
      // body: ListView(),
      body: Center(
        child: SizedBox(
          width: 650,
          child: Column(
            children: [
              ListTile(
                title: Text(locator<S>().maxServicesToStoreInArchive),
                trailing: SizedBox(
                  width: 60,
                  child: TextFormField(
                    // expands: false,
                    keyboardType: TextInputType.number,
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]{1,4}$')),
                    ],
                    controller: TextEditingController(
                      text: ref.read(hiveArchiveLimit).toString(),
                    ),
                    // hintText:,
                    onChanged: (value) {
                      ref.read(hiveArchiveLimit.notifier).state =
                          int.parse(value);
                    },
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(locator<S>().magnificationOfServiceWidgets),
                subtitle: Slider(
                  min: 0.7,
                  max: 1.6,
                  value: ref.watch(serviceCardMagnifying),
                  onChanged: (value) {
                    ref.read(serviceCardMagnifying.notifier).state = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
