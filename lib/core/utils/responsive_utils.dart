import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double horizontalPadding;
  static late double verticalPadding;
  static late bool isTablet;
  
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    isTablet = screenWidth > 600;
    horizontalPadding = screenWidth * 0.05;
    verticalPadding = screenHeight * 0.02;
  }

  // Font sizes
  static double get titleFontSize => isTablet ? 24.0 : 20.0;
  static double get subtitleFontSize => isTablet ? 18.0 : 16.0;
  static double get bodyFontSize => isTablet ? 16.0 : 14.0;

  // Spacing
  static double get spacingHeight => screenHeight * 0.025;
  static double get buttonHeight => isTablet ? 65.0 : 55.0;
  
  // Image sizes
  static double get imageSize => isTablet ? screenWidth * 0.25 : screenWidth * 0.2;

  // Border radius
  static double get borderRadius => screenWidth * 0.04;
} 