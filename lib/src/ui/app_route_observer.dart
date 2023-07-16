import 'dart:async';

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouteObserver extends RouteObserver {
  AppRouteObserver(this.ref);

  final WidgetRef ref;

  Future<void> saveLastRoute(Route<dynamic>? lastRoute) async {
    unawaited(ref.read(audioPlayer).stop());
    unawaited(ref.read(proofRecorder).stop());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_route', lastRoute?.settings.name ?? '/');
    log.fine('route: ${lastRoute?.settings.name ?? ''}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    saveLastRoute(previousRoute); // note : take route name in stacks below
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    saveLastRoute(route); // note : take new route name that just pushed
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    saveLastRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    saveLastRoute(newRoute);
  }
}
