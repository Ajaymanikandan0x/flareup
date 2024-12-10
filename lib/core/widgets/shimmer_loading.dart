import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flareup/core/theme/app_palette.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark 
          ? AppPalette.shimmerDarkBase
          : AppPalette.shimmerLightBase,
      highlightColor: isDark
          ? AppPalette.shimmerDarkHighlight
          : AppPalette.shimmerLightHighlight,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
} 