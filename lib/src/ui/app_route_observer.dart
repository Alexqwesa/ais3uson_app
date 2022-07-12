import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouteObserver extends RouteObserver {
  AppRouteObserver(this.ref);

  final WidgetRef ref;

  Future<void> saveLastRoute(Route? lastRoute) async {
    await ref.read(audioPlayer).stop();
    await ref.read(proofRecorder).stop();
    // ref.read() // todo: stop stt
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_route', lastRoute?.settings.name ?? '/');
    log.fine('route: ${lastRoute?.settings.name ?? ''}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    saveLastRoute(previousRoute); // note : take route name in stacks below
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    saveLastRoute(route); // note : take new route name that just pushed
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    saveLastRoute(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    saveLastRoute(newRoute);
  }
}
