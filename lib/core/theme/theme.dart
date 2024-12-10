import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static _border([Color color = AppPalette.darkCard]) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 3),
      );

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.darkBackground,
    cardColor: AppPalette.darkCard,
    textTheme: GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppPalette.darkText,
      displayColor: AppPalette.darkText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.darkBackground,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      border: _border(),
      focusedBorder: _border(AppPalette.gradient2),
      errorBorder: _border(AppPalette.error),
    ),
  );

  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.lightBackground,
    cardColor: AppPalette.lightCard,
    textTheme: GoogleFonts.openSansTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: AppPalette.lightText,
      displayColor: AppPalette.lightText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.lightBackground,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      border: _border(),
      focusedBorder: _border(AppPalette.gradient2),
      errorBorder: _border(AppPalette.error),
    ),
  );
}
