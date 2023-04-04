import 'package:ais3uson_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Provider with support switching dark/light.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category UI Root}
final standardTheme = StateNotifierProvider<ThemesData, ThemeMode>((ref) {
  return ThemesData();
});

class ThemesData extends StateNotifier<ThemeMode> {
  ThemesData()
      : super(
          [ThemeMode.light, ThemeMode.dark]
              .elementAt(locator<SharedPreferences>().getInt(name) ?? 0),
        );

  static const name = 'themeIndex';

  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    ),
    displayLarge: GoogleFonts.openSans(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.openSans(
      fontSize: 22,
      // fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headlineSmall: GoogleFonts.openSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleLarge: GoogleFonts.ubuntu(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = lightTextTheme.copyWith(
    bodyLarge: GoogleFonts.openSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.normal,
    ),
    displayLarge: GoogleFonts.openSans(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineMedium: GoogleFonts.openSans(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: GoogleFonts.openSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.ubuntu(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  @override
  set state(ThemeMode value) {
    super.state = value;
    locator<SharedPreferences>().setInt(name, value == ThemeMode.light ? 0 : 1);
  }

  static ThemeData light() {
    return ThemeData(
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.black;
          },
        ),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        // backgroundColor: Colors.white,
      ),
      splashColor: Colors.lightGreenAccent.shade100,
      cardTheme: const CardTheme(elevation: 12),
      dialogBackgroundColor: Colors.grey[50],
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        // backgroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      dividerColor: Colors.black54,
      textTheme: lightTextTheme,
      colorScheme: const ColorScheme.light()
          .copyWith(primary: Colors.blue, secondary: Colors.blue[400]),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        // foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
      ),
      splashColor: Colors.indigoAccent.shade700,
      cardTheme: const CardTheme(elevation: 12),
      dialogBackgroundColor: Colors.white12,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        // foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      primaryColor: Colors.blue[700],
      dividerColor: Colors.white54,
      textTheme: darkTextTheme,
      colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.blue),
    );
  }
}
