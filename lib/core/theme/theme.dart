import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static _border([Color color = AppPalette.cardColor]) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 3),
      );
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.backGroundColor,
    textTheme: GoogleFonts.openSansTextTheme(),
    appBarTheme: const AppBarTheme(backgroundColor: AppPalette.backGroundColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      border: _border(),
      focusedBorder: _border(AppPalette.gradient2),
      errorBorder: _border(AppPalette.error),
    ),
  );
}
