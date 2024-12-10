import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/utils/responsive_utils.dart';
import 'on_boarding_list.dart';

class OnboardingTextCard extends StatelessWidget {
  final OnBoarding onBoardingModel;
  const OnboardingTextCard({required this.onBoardingModel, super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding,
      ),
      child: Column(
        children: [
          Text(
            onBoardingModel.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: Responsive.titleFontSize,
              fontWeight: FontWeight.bold,
              color: AppPalette.darkText,
            ),
          ),
          SizedBox(
            height: Responsive.spacingHeight,
          ),
          Text(
            onBoardingModel.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: Responsive.bodyFontSize,
              fontWeight: FontWeight.w500,
              color: AppPalette.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
