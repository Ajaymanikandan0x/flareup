import 'package:flutter/material.dart';

class AppPalette {
  static const Color backGroundColor = Color(0xFF000000);
  static const Color gradient1 = Color(0xFF439DFE);
  static const Color gradient2 = Color(0xFFF687FF);
  static const Color mainText = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color hintTextColor = Color(0xFF747688);
  static const Color formIconColor = Color(0xFF747688);
  static const Color cardColor = Color(0xFF2D303A);
  static const Color paymentColor = Color(0xFFEC441E);
  static const Color error = Colors.redAccent;
  static const Gradient myGradient = LinearGradient(
    colors: [
      gradient1,
      gradient2,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
