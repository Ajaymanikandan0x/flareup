import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/responsive_utils.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark 
        ? AppPalette.shimmerDarkBase
        : AppPalette.shimmerLightBase;
    final highlightColor = isDark
        ? AppPalette.shimmerDarkHighlight
        : AppPalette.shimmerLightHighlight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1500),
      child: Column(
        children: [
          // Avatar shimmer
          CircleAvatar(
            radius: Responsive.imageSize,
            backgroundColor:
                isDark ? AppPalette.darkCard : AppPalette.lightCard,
          ),
          SizedBox(height: Responsive.spacingHeight),

          // Change photo button shimmer
          Container(
            width: Responsive.screenWidth * 0.4,
            height: Responsive.buttonHeight * 0.5,
            decoration: BoxDecoration(
              color: isDark ? AppPalette.darkCard : AppPalette.lightCard,
              borderRadius: BorderRadius.circular(Responsive.borderRadius),
            ),
          ),
          SizedBox(height: Responsive.spacingHeight * 2),

          // List tiles shimmer
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) =>
                SizedBox(height: Responsive.spacingHeight),
            itemBuilder: (context, index) => Container(
              height: Responsive.buttonHeight,
              decoration: BoxDecoration(
                color: isDark ? AppPalette.darkCard : AppPalette.lightCard,
                borderRadius: BorderRadius.circular(Responsive.borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
