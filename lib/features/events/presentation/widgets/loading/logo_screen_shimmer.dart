import 'package:flutter/material.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/shimmer_loading.dart';

class EventLogoShimmer extends StatelessWidget {
  const EventLogoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background shimmer
          ShimmerLoading(
            isLoading: true,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: isDark ? AppPalette.darkCard : AppPalette.lightCard,
            ),
          ),

          // Content shimmer
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(Responsive.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button shimmer
                  ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Date shimmer
                  Padding(
                    padding: EdgeInsets.only(top: Responsive.spacingHeight),
                    child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        width: 120,
                        height: Responsive.bodyFontSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Title shimmer
                  ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      width: double.infinity,
                      height: Responsive.titleFontSize * 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  SizedBox(height: Responsive.spacingHeight),

                  // Location shimmer
                  ShimmerLoading(
                    isLoading: true,
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: Responsive.spacingWidth * 0.5),
                        Container(
                          width: 200,
                          height: Responsive.bodyFontSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Responsive.spacingHeight * 2),

                  // Members going shimmer
                  ShimmerLoading(
                    isLoading: true,
                    child: Row(
                      children: [
                        Row(
                          children: List.generate(
                            3,
                            (index) => Container(
                              margin: EdgeInsets.only(
                                right: index != 2 ? -8 : 0,
                              ),
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.spacingWidth),
                        Container(
                          width: 60,
                          height: Responsive.bodyFontSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Responsive.spacingHeight * 2),

                  // Button shimmer
                  ShimmerLoading(
                    isLoading: true,
                    child: Container(
                      width: double.infinity,
                      height: Responsive.buttonHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Responsive.borderRadius),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}