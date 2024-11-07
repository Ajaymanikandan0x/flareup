import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/widgets/primary_button.dart';
import '../widgets/on_board/on_board_image.dart';
import '../widgets/on_board/on_boarding_image_Card.dart';
import '../widgets/on_board/on_boarding_text_card.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController1 = PageController(initialPage: 0);
  final PageController _pageController2 = PageController(initialPage: 0);
  int _currentIndex = 0;

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
              controller: _pageController1,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: OnBoardingImageCard(
                    onBoardingModel: onBoardingList[index],
                  ),
                );
              }),
          Positioned(
            bottom: 160, // Adjust as needed
            left: 0,
            right: 0,
            child: OnboardingTextCard(
              onBoardingModel: onBoardingList[_currentIndex],
            ),
          ),
          Positioned(
            bottom: 110, // Adjust as needed
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController1,
                count: onBoardingList.length,
                effect: const ExpandingDotsEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: AppPalette.gradient2),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: AppPalette.myGradient,
              ),
              child: Text('Skip'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 25,
            right: 25,
            child: PrimaryButton(
              elevation: 0,
              onTap: () async {
                if (_pageController1.hasClients && _currentIndex < onBoardingList.length) {
                  if (_currentIndex == onBoardingList.length - 1) {
                    Navigator.pushNamed(context, AppRouts.signIn);
                  } else {
                    await Future.delayed(const Duration(milliseconds: 100));
                    _pageController1.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                    );
                    _pageController2.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                    );
                  }
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

class OnBoarding {
  String title;
  String description;
  String image;

  OnBoarding({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnBoarding> onBoardingList = [
  OnBoarding(
    title: ' Can be accessed from anywhere at any time',
    image: OnBoardImage.kOnboarding1,
    description:
        'The essential language learning tools and resources you need to seamlessly transition into mastering a new language',
  ),
  OnBoarding(
      title: 'Offers a dynamic and interactive experience',
      image: OnBoardImage.kOnboarding2,
      description:
          'Engaging features including test, story telling, and conversations that motivate and inspire language learners to unlock their full potential'),
  OnBoarding(
      title: "Experience the Premium Features with Our App",
      image: OnBoardImage.kOnboarding3,
      description:
          'Updated TalkGpt with premium materials and a dedicated following, providing language learners with immersive content for effective learning'),
];
