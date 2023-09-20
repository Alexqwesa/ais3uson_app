import 'package:ais3uson_app/settings.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locale_switcher/locale_switcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${loc.settings}:'),
      ),
      // body: ListView(),
      body: Center(
        child: SizedBox(
          width: 650,
          child: Column(
            children: [
              ListTile(
                title: Text(loc.maxServicesToStoreInArchive),
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
                      text: ref.read(journalArchiveSizeProvider).toString(),
                    ),
                    // hintText:,
                    onChanged: (value) {
                      ref.read(journalArchiveSizeProvider.notifier).state =
                          int.parse(value);
                    },
                  ),
                ),
              ),
              const Divider(),
              SettingServiceSizeWidget(
                  title: loc.magnificationOfServiceWidgets),
              const Divider(),
              LocaleSwitcher.menu(
                title: loc.chooseLanguage,
                numberOfShown: 200,
              )
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
    this.title,
    super.key,
  });

  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final titleText = title ?? loc.magnification;

    return ListTile(
      title: Text(titleText),
      subtitle: Slider(
        min: 60, // 60%
        max: 220, // 220%
        value: (ref.watch(tileMagnificationProvider) * 100).toInt().toDouble(),
        onChanged: (value) {
          ref.read(tileMagnificationProvider.notifier).state = value / 100;
        },
      ),
    );
  }
}
