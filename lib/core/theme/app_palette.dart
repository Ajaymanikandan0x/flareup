import 'package:flutter/material.dart';

class AppPalette {
  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    colors: [gradient1, gradient2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [darkCard, Color(0xFF2C2C2C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Basic Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Colors.redAccent;
  static const Color success = Color(0xFF4CAF50);
  static const Color payment = Color(0xFFEC441E);
  static const Color info = Color(0xFF2196F3);

  // Status Colors
  static const Color active = Color(0xFF4CAF50); // Green
  static const Color cancelled = Color(0xFFE53935); // Red
  static const Color pending = Color(0xFFFFA726); // Orange
  static const Color draft = Color(0xFF9E9E9E); // Grey

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightText = Color(0xFF1D2026);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightHint = Color(0xFF747688);
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color lightGradientStart = Color(0xFF4FC3F7); // Light blue
  static const Color lightGradientEnd = Color(0xFF29B6F6); // Deeper blue

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkCard = Color(0xFF1D2026);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkHint = Color(0xFF747688);
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color darkGradientStart = Color(0xFF1E88E5); // Dark blue
  static const Color darkGradientEnd = Color(0xFF1976D2); // Deeper dark blue

  // Shimmer Colors
  static const Color shimmerDarkBase = Color(0xFF262626);
  static const Color shimmerDarkHighlight = Color(0xFF3D3D3D);
  static const Color shimmerLightBase = Color(0xFFE0E0E0);
  static const Color shimmerLightHighlight = Color(0xFFF5F5F5);

  // Gradient Colors
  static const Color gradient1 = Color(0xFF439DFE);
  static const Color gradient2 = Color(0xFFF687FF);
}
