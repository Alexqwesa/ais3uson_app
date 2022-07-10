/// # ui_root - Top level GUI classes
///
/// These classes provide GUI for:
///
/// - Root Widget of app [AppRoot], which provides:
/// - Switch between archive and normal views.
/// - [ArchiveMaterialApp] or [MainMaterialApp] which provides:
/// - Routes, themes(via provider [standardTheme]), translations (`tr()`).
/// - [HomeScreen] screen for displaying main menu and [ListOfProfiles]. It is initial route of app.
/// - [SettingsScreen],
/// - [DevScreen] - about developers + tests.
///
library ui_root;

import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';

export 'package:ais3uson_app/src/ui/app_root.dart';
export 'package:ais3uson_app/src/ui/dev_screen.dart';
export 'package:ais3uson_app/src/ui/home_screen.dart';
export 'package:ais3uson_app/src/ui/settings_screen.dart';
export 'package:ais3uson_app/src/ui/themes_data.dart';

// export 'ui_departments/list_of_profiles.dart';
