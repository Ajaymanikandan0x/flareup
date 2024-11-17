
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_palette.dart';
import 'on_boarding_list.dart';

class OnboardingTextCard extends StatelessWidget {
  final OnBoarding onBoardingModel;
  const OnboardingTextCard({required this.onBoardingModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        children: [
          Text(
            onBoardingModel.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppPalette.white,
            ).copyWith(fontSize: 24),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            onBoardingModel.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppPalette.white)
                .copyWith(color: AppPalette.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
