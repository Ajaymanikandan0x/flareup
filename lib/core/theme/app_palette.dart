import 'package:flutter/material.dart';

class AppPalette {
  static const Color gradient1 = Color(0xFF439DFE);
  static const Color gradient2 = Color(0xFFF687FF);
  static const Color paymentColor = Color(0xFFEC441E);
  static const Color error = Colors.redAccent;

  static const Color darkBackground = Color(0xFF000000);
  static const Color darkCard = Color(0xFF1D2026);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkHint = Color(0xFF747688);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightText = Color(0xFF1D2026);
  static const Color lightHint = Color(0xFF747688);

  static const Gradient myGradient = LinearGradient(
    colors: [gradient1, gradient2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
