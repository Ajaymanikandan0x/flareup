import 'package:flutter/material.dart';

import 'on_boarding_list.dart';

class OnBoardingImageCard extends StatelessWidget {
  final OnBoarding onBoardingModel;
  const OnBoardingImageCard({
    super.key,
    required this.onBoardingModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(onBoardingModel.image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
