import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

TextStyle textTheme({
  double? fontSize = 15,
}) {
  return TextStyle(
      color: AppPalette.mainText,
      fontSize: fontSize,
      fontWeight: FontWeight.w600);
}
