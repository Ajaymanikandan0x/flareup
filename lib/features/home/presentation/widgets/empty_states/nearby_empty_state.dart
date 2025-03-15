import 'package:flutter/material.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/utils/responsive_utils.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/widgets/primary_button.dart';

class NearbyEmptyState extends StatelessWidget {
  final VoidCallback onSearchDestinations;

  const NearbyEmptyState({
    super.key,
    required this.onSearchDestinations,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding,
        vertical: isSmallScreen
            ? Responsive.verticalPadding * 0.8
            : Responsive.verticalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated icon with sparkles
          FractionallySizedBox(
            widthFactor: isSmallScreen ? 0.8 : 0.9,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppPalette.darkCard
                              : AppPalette.lightCard,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.08),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Lottie.asset(
                          'assets/lottie/Lighthouse.json',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Responsive sparkle animations
                      ...List.generate(3, (index) {
                        return Positioned(
                          top: index * (isSmallScreen ? 12.0 : 15.0),
                          right: index * (isSmallScreen ? -6.0 : -8.0),
                          child: Icon(
                            Icons.star,
                            size: (isSmallScreen ? 14 : 16) - (index * 2),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),

          // Message text
          Text(
            "Check nearby destinations",
            textAlign: TextAlign.center,
            style: AppTextStyles.primaryTextTheme().copyWith(
              fontSize: isSmallScreen
                  ? Responsive.subtitleFontSize * 0.9
                  : Responsive.subtitleFontSize,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              color: isDark
                  ? AppPalette.darkTextSecondary
                  : AppPalette.lightTextSecondary,
            ),
          ),
          SizedBox(height: isSmallScreen ? 24 : 32),

          // Search button
          PrimaryButton(
            onTap: onSearchDestinations,
            text: 'Search Destinations',
            width: screenSize.width * (isSmallScreen ? 0.45 : 0.5),
            height: Responsive.buttonHeight * 0.7,
            fontSize: isSmallScreen
                ? Responsive.bodyFontSize * 0.9
                : Responsive.bodyFontSize,
          ),
        ],
      ),
    );
  }
}
