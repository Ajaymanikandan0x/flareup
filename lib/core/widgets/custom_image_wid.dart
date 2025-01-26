import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../utils/responsive_utils.dart';

class CustomImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    // Calculate responsive dimensions
    final responsiveWidth = width ?? Responsive.screenWidth * 0.8;
    final responsiveHeight = height ?? Responsive.screenHeight * 0.3;
    final iconSize = responsiveWidth * 0.25;
    final fontSize = Responsive.isTablet ? 14.0 : 12.0;
    
    // Get theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: responsiveWidth,
      height: responsiveHeight,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: responsiveWidth,
        height: responsiveHeight,
        placeholder: (context, url) => placeholder ?? Center(
          child: CircularProgressIndicator(
            color: AppPalette.gradient2,
          ),
        ),
        errorWidget: (context, url, error) => errorWidget ?? Container(
          color: isDark ? AppPalette.darkCard : AppPalette.lightCard,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: iconSize,
                color: isDark 
                    ? AppPalette.darkHint 
                    : AppPalette.lightHint,
              ),
              SizedBox(height: Responsive.spacingHeight * 0.5),
              Text(
                'Image not available',
                style: TextStyle(
                  color: isDark 
                      ? AppPalette.darkTextSecondary 
                      : AppPalette.lightTextSecondary,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}