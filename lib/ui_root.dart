/// # Top level GUI classes
///
/// These classes provide GUI for:
///
/// - Root Widget of app [AppRoot], which provides:
/// - Routes[routerProvider],
/// - Themes(via provider [appThemeProvider]),
/// - [HomeScreen] screen for displaying main menu and [ListOfDepartments].
/// - [SettingsScreen],
/// - [DevScreen] - about developers + tests.
///
library ui_root;

import 'package:ais3uson_app/settings.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';

export 'package:ais3uson_app/src/ui/app_root.dart';
export 'package:ais3uson_app/src/ui/app_route_observer.dart';
export 'package:ais3uson_app/src/ui/app_theme_provider.dart';
export 'package:ais3uson_app/src/ui/archive_shell_route.dart';
export 'package:ais3uson_app/src/ui/dev_screen.dart';
export 'package:ais3uson_app/src/ui/home_screen.dart';
export 'package:ais3uson_app/src/ui/router_provider.dart'
    show routeProvider, routerProvider;

// export 'ui_departments/list_of_departments.dart';
