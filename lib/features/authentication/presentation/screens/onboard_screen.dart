import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/text_theme.dart';
import '../../../../core/utils/responsive_utils.dart';
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
    // Initialize responsive utilities
    Responsive.init(context);

    // Calculate responsive dimensions
    final skipButtonHeight = Responsive.screenHeight * 0.045;
    final skipButtonPadding = Responsive.horizontalPadding * 0.6;
    final skipFontSize = Responsive.bodyFontSize;
    final indicatorBottom = Responsive.screenHeight * 0.15;
    final textCardBottom = Responsive.screenHeight * 0.22;
    final buttonBottom = Responsive.screenHeight * 0.03;
    final buttonWidth = Responsive.screenWidth * 0.85;
    final buttonHeight = Responsive.buttonHeight * 0.8;

    return Scaffold(
      backgroundColor: AppPalette.darkCard,
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
            bottom: textCardBottom,
            left: 0,
            right: 0,
            child: OnboardingTextCard(
              onBoardingModel: onBoardingList[_currentIndex],
            ),
          ),
          Positioned(
            bottom: indicatorBottom,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: onBoardingList.length,
                effect: ExpandingDotsEffect(
                    dotWidth: Responsive.screenWidth * 0.025,
                    dotHeight: Responsive.screenWidth * 0.025,
                    activeDotColor: AppPalette.gradient2),
              ),
            ),
          ),
          Positioned(
            top: Responsive.screenHeight * 0.06,
            right: Responsive.horizontalPadding,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRouts.signIn);
              },
              child: Container(
                height: skipButtonHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: skipButtonPadding,
                  vertical: skipButtonPadding * 0.5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(skipButtonHeight * 0.5),
                  gradient: AppPalette.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Skip',
                  style: AppTextStyles.primaryTextTheme(fontSize: skipFontSize),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: buttonBottom,
            left: Responsive.horizontalPadding,
            right: Responsive.horizontalPadding,
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
              borderRadius: Responsive.borderRadius,
              height: buttonHeight,
              width: buttonWidth,
            ),
          ),
        ],
      ),
    );
  }
}
