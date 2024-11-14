import 'package:flutter/material.dart';

import 'on_boarding_list.dart';

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