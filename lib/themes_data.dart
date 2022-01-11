import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: prefer_mixin
class StandardTheme with ChangeNotifier {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyText2: GoogleFonts.openSans(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 26.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline4: GoogleFonts.openSans(
      fontSize: 22.0,
      // fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline5: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = lightTextTheme.copyWith(
    bodyText1: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.openSans(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.normal,
    ),
    headline1: GoogleFonts.openSans(
      fontSize: 28.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 26.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline4: GoogleFonts.openSans(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline5: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  /// store theme state: light/dark
  int themeIndex = 0;

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
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
      primarySwatch: Colors.blue,
      accentColor: Colors.blue[400],
      dividerColor: Colors.black54,
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
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
      accentColor: Colors.blue,
      primarySwatch: Colors.blue,
      dividerColor: Colors.white54,
      textTheme: darkTextTheme,
    );
  }

  ThemeMode current() {
    return themeIndex == 0 ? ThemeMode.light : ThemeMode.dark;
  }

  void changeIndex(int index) {
    themeIndex = index;
    notifyListeners();
  }
}
