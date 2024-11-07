import 'package:flutter/material.dart';

import '../../screens/onboard_screen.dart';

class OnBoardingImageCard extends StatelessWidget {
  final  OnBoarding onBoardingModel;
  const OnBoardingImageCard({
    super.key,
    required this.onBoardingModel,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      onBoardingModel.image,
      height: 300,
      width: double.maxFinite,
      fit: BoxFit.fitWidth,
    );
  }
}