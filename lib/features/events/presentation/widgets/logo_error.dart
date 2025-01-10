import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/responsive_utils.dart';

class EventLogoErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const EventLogoErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate responsive dimensions
    final iconSize = Responsive.screenWidth * 0.18;
    final buttonHeight = Responsive.buttonHeight * 0.8;
    final buttonWidth = Responsive.screenWidth * 0.4;
    final contentPadding = Responsive.horizontalPadding * 1.5;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated error icon
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.error_outline,
                    size: iconSize,
                    color: AppPalette.error,
                  ),
                );
              },
            ),
            
            SizedBox(height: Responsive.spacingHeight * 1.2),
            
            // Error message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.isTablet 
                    ? Responsive.subtitleFontSize 
                    : Responsive.bodyFontSize,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppPalette.darkText
                    : AppPalette.lightText,
                height: 1.4,
                decoration: TextDecoration.none,
              ),
            ),
            
            if (onRetry != null) ...[
              SizedBox(height: Responsive.spacingHeight * 1.5),
              
              // Retry button with hover effect
              Material(
                borderRadius: BorderRadius.circular(Responsive.borderRadius),
                child: InkWell(
                  onTap: onRetry,
                  borderRadius: BorderRadius.circular(Responsive.borderRadius),
                  child: Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    decoration: BoxDecoration(
                      gradient: AppPalette.primaryGradient,
                      borderRadius: BorderRadius.circular(Responsive.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.gradient2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        SizedBox(width: Responsive.spacingWidth * 0.5),
                        Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.bodyFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}