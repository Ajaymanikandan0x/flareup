import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

import '../utils/responsive_utils.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final IconData? iconData;

  const PrimaryButton({
    super.key,
    required this.onTap,
    required this.text,
    this.width,
    this.height,
    this.elevation = 5,
    this.borderRadius = 15,
    this.fontSize,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final size = MediaQuery.of(context).size;

    final responsiveWidth = width ?? Responsive.screenWidth * 0.85;
    final responsiveHeight = height ?? Responsive.buttonHeight;
    final responsiveFontSize = fontSize ?? Responsive.bodyFontSize;
    final responsiveBorderRadius = borderRadius ?? Responsive.borderRadius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: responsiveHeight,
        width: responsiveWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
          gradient: AppPalette.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData != null) ...[
                Icon(
                  iconData,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppPalette.darkCard
                      : AppPalette.lightCard,
                  size: responsiveFontSize,
                ),
                SizedBox(width: size.width * 0.02),
              ],
              Text(
                text,
                style: AppTextStyles.primaryTextTheme(
                  fontSize: responsiveFontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
