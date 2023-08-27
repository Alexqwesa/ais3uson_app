import 'dart:math';

import 'package:ais3uson_app/src/l10n/localization_provider.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleSwitcher extends ConsumerWidget {
  final String? title;

  final int numberOfShown;

  final bool inRow;

  const LocaleSwitcher({
    super.key,
    this.title = 'Choose the language:',
    this.numberOfShown = 4,
    this.inRow = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!inRow)
            Padding(
              padding: const EdgeInsets.all(4),
              child: Center(child: Text(title ?? '')),
            ),
          Row(
            children: [
              if (inRow)
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Center(child: Text(title ?? '')),
                ),
              Expanded(
                child: AnimatedToggleSwitch<String>.rolling(
                  current: ref.watch(appLocaleProvider).langCode,
                  values: [
                    LocaleState.systemLocale,
                    ...AppLocalizations.supportedLocales
                        .take(numberOfShown) // chose most used
                        .map((e) => e.languageCode),
                  ],
                  onChanged: (i) async {
                    // final localeCode = Intl.canonicalizedLocale(i);
                    // final locale = Locale(localeCode);
                    // await AppLocalizations.delegate.load(locale);
                    ref.read(appLocaleProvider.notifier).state = LocaleState(i);
                    // ref.read(appLocaleProvider.notifier).update(locale);
                    // S.load(Locale(ref.watch(curLang)));
                  },
                  loading: false,
                  innerColor: Colors.white38,
                  iconBuilder: (value, size, foreground) {
                    if (value == LocaleState.systemLocale) {
                      return SizedBox.fromSize(
                        size: size,
                        child: const ClipOval(child: Icon(Icons.language)),
                      );
                    }
                    if (value == 'en') {
                      return CircleFlag('us',
                          size: min(size.width, size.height));
                    }
                    return CircleFlag(value,
                        size: min(size.width, size.height));
                  },

                  // for deactivating loading animation
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
