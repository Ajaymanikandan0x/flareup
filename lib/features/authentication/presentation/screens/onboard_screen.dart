import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/text_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/on_board/on_boarding_list.dart';
import '../widgets/on_board/on_boarding_text_card.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backGroundColor,
      body: Stack(
        children: [
          PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: onBoardingList.length,
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(onBoardingList[index].image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                );
              }),
          Positioned(
            bottom: 160,
            left: 0,
            right: 0,
            child: OnboardingTextCard(
              onBoardingModel: onBoardingList[_currentIndex],
            ),
          ),
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: onBoardingList.length,
                effect: const ExpandingDotsEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: AppPalette.gradient2),
              ),
            ),
          ),
          Positioned(
            top: 48,
            right: 24,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRouts.signIn);
              },
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: AppPalette.myGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:  Text(
                  'Skip',
                  style: AppTextStyles.primaryTextTheme(fontSize: 14),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 25,
            right: 25,
            child: PrimaryButton(
              elevation: 0,
              onTap: () {
                if (_currentIndex == onBoardingList.length - 1) {
                  Navigator.pushReplacementNamed(context, AppRouts.signIn);
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                }
              },
              text: _currentIndex == onBoardingList.length - 1
                  ? 'Get Started'
                  : 'Next',
              borderRadius: 20,
              height: 46,
              width: 327,
            ),
          ),
        ],
      ),
    );
  }
}
