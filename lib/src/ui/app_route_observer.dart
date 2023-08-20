import 'dart:async';

import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppRouteObserver extends RouteObserver {
  AppRouteObserver(this.ref);

  final Ref ref;

  static const name = 'last_route';

  Future<void> cleanupOnRouteChange(Route<dynamic>? lastRoute) async {
    // stop media on route change
    unawaited(ref.read(audioPlayer).stop());
    unawaited(ref.read(recorderProvider.notifier).stop());
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    cleanupOnRouteChange(
        previousRoute); // note : take route name in stacks below
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    cleanupOnRouteChange(route); // note : take new route name that just pushed
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    cleanupOnRouteChange(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute?.settings.name != oldRoute?.settings.name ||
        newRoute?.settings.arguments != oldRoute?.settings.arguments) {
      cleanupOnRouteChange(newRoute);
    }
  }
}
