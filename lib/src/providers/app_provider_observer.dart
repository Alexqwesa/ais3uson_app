import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppProviderObserver extends ProviderObserver {
  bool firstTime = true;

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    if (provider.name == 'routeProvider' && firstTime) {
      firstTime = false;
      // final controller = container.read(appRouteProvider.notifier);
      // container
      //     .read(routeProvider)
      //     .routeInformationProvider
      //     .removeListener(controller.update);
      // Future.microtask(() =>
      //     container
      //         .read(routeProvider)
      //         .routeInformationProvider
      //         .addListener(controller.update));
    }
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    // if (provider.name == 'routeProvider') {
    //   final controller = container.read(appRouteProvider.notifier);
    //   Future.microtask(() => container
    //       .read(routeProvider)
    //       .routeInformationProvider
    //       .removeListener(controller.update));
    // }
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      final toPrint = '''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''';
      print(toPrint.substring(0, min(200, toPrint.length)));
    }
  }
}
