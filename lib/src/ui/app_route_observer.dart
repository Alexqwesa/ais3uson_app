import 'package:ais3uson_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouteObserver extends RouteObserver {
  Future<void> saveLastRoute(Route? lastRoute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_route', lastRoute?.settings.name ?? '/');
    log.fine('route: ${lastRoute?.settings.name ?? ''}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    saveLastRoute(previousRoute); // note : take route name in stacks below
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    saveLastRoute(route); // note : take new route name that just pushed
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    saveLastRoute(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    saveLastRoute(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
