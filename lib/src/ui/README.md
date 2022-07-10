# ui_root - Top level GUI classes

These classes provide GUI for:

- Root Widget of app [AppRoot], which provides:
  - Switch between archive and normal views.
  - [ArchiveMaterialApp] or [MainMaterialApp] which provides:
    - Routes, themes(via provider [standardTheme]), translations (`tr()`).
    - [HomeScreen] screen for displaying main menu and [ListOfProfiles]. It is initial route of app.
    - [SettingsScreen],
    - [DevScreen] - about developers + tests.
