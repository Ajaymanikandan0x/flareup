import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // Base method for common properties
  static TextStyle _baseTextStyle({
    double fontSize = 15,
    Color? color,
    FontStyle? fontStyle,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }

  static TextStyle primaryTextTheme({
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return _baseTextStyle(
      fontSize: fontSize ?? 15,
      color: null,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
    );
  }

  static TextStyle hindTextTheme({
    double fontSize = 15,
    FontStyle? fontStyle,
  }) {
    return _baseTextStyle(
      fontSize: fontSize,
      color: null,
      fontStyle: fontStyle,
    );
  }

  static TextStyle paymentTextTheme({
    double fontSize = 15,
    FontStyle? fontStyle,
  }) {
    return _baseTextStyle(
      fontSize: fontSize,
      color: AppPalette.payment,
      fontStyle: fontStyle,
    );
  }

  static TextStyle gradientText({
    double fontSize = 15,
    FontStyle? fontStyle,
  }) {
    return _baseTextStyle(
      fontSize: fontSize,
      color: AppPalette.gradient2,
      fontStyle: fontStyle,
    );
  }
}
