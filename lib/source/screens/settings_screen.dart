import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/providers/providers_of_settings.dart';
import 'package:ais3uson_app/source/screens/service_related/service_card.dart';
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
              const SettingServiceSizeWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for changing size of [ServiceCard] view in list of services.
class SettingServiceSizeWidget extends ConsumerWidget {
  const SettingServiceSizeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(locator<S>().magnificationOfServiceWidgets),
      subtitle: Slider(
        min: 60, // 60%
        max: 180, // 180%
        value: (ref.watch(serviceCardMagnifying) * 100).toInt().toDouble(),
        onChanged: (value) {
          ref.read(serviceCardMagnifying.notifier).state = value / 100;
        },
      ),
    );
  }
}
