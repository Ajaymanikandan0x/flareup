import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../utils/responsive_utils.dart';

enum ImageSource { network, asset, file }

class CustomImageWidget extends StatelessWidget {
  final String imageUrl;
  final ImageSource source;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit? fit;
  final Duration fadeInDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final bool enableFadeAnimation;

  const CustomImageWidget({
    super.key,
    required this.imageUrl,
    this.source = ImageSource.network,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.fit = BoxFit.cover,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
    this.enableFadeAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    // Calculate responsive dimensions
    final screenWidth = Responsive.screenWidth;
    final screenHeight = Responsive.screenHeight;

    final responsiveWidth = width ?? screenWidth * 0.8;
    final responsiveHeight = height ?? screenHeight * 0.3;

    final iconSize = responsiveWidth * 0.25;
    final fontSize = Responsive.isTablet ? 14.0 : 12.0;

    // Get theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: responsiveWidth,
          height: responsiveHeight,
          child: _buildImage(
            isDark: isDark,
            iconSize: iconSize,
            fontSize: fontSize,
          ),
        );
      },
    );
  }

  Widget _buildImage({
    required bool isDark,
    required double iconSize,
    required double fontSize,
  }) {
    // Create default placeholder and error widgets
    final defaultPlaceholder = Center(
      child: CircularProgressIndicator(
        color: AppPalette.gradient2,
      ),
    );

    final defaultErrorWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: iconSize,
            color: isDark ? AppPalette.darkHint : AppPalette.lightHint,
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
    );

    // Validate image url
    if (imageUrl.isEmpty) {
      return errorWidget ?? defaultErrorWidget;
    }

    // Handle different image sources
    switch (source) {
      case ImageSource.network:
        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit ?? BoxFit.cover,
          fadeInDuration: enableFadeAnimation ? fadeInDuration : Duration.zero,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          maxWidthDiskCache: 1000, // Optimize disk cache
          maxHeightDiskCache: 1000,
          placeholder: (context, url) => placeholder ?? defaultPlaceholder,
          errorWidget: (context, url, error) {
            debugPrint('Image error: $error for URL: $url');
            return errorWidget ?? defaultErrorWidget;
          },
        );

      case ImageSource.asset:
        return Image.asset(
          imageUrl,
          fit: fit ?? BoxFit.cover,
          frameBuilder: enableFadeAnimation
              ? (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: fadeInDuration,
                    curve: Curves.easeOut,
                    child: child,
                  );
                }
              : null,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Asset image error: $error');
            return errorWidget ?? defaultErrorWidget;
          },
        );

      case ImageSource.file:
        final file = File(imageUrl);
        if (!file.existsSync()) {
          return errorWidget ?? defaultErrorWidget;
        }
        return Image.file(
          file,
          fit: fit ?? BoxFit.cover,
          frameBuilder: enableFadeAnimation
              ? (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: fadeInDuration,
                    curve: Curves.easeOut,
                    child: child,
                  );
                }
              : null,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('File image error: $error');
            return errorWidget ?? defaultErrorWidget;
          },
        );
    }
  }

  /// Checks if a URL is a valid image URL
  static bool isValidImageUrl(String url) {
    final validExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.webp',
      '.svg',
      '.bmp'
    ];
    return url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://')) &&
        validExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }
}
