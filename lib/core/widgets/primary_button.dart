import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/responsive_utils.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final IconData? iconData;
  final bool isLoading;
  final bool isEnabled;

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
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsiveWidth = width ?? Responsive.screenWidth * 0.85;
    final responsiveHeight = height ?? Responsive.buttonHeight;
    final responsiveFontSize = fontSize ?? Responsive.bodyFontSize;
    final responsiveBorderRadius = borderRadius ?? Responsive.borderRadius;

    return GestureDetector(
      onTap: (!isEnabled || isLoading) ? null : onTap,
      child: Opacity(
        opacity: (!isEnabled || isLoading) ? 0.6 : 1.0,
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
            child: isLoading
                ? LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: responsiveHeight * 0.4,
                  )
                : Row(
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
      ),
    );
  }
}
