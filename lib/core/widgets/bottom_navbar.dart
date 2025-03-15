import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../features/chat/presentation/screens/chat.dart';
import '../../features/home/presentation/screens/home.dart';
import '../../features/location/presentation/screens/location.dart';
import '../theme/app_palette.dart';

class AppNav extends StatefulWidget {
  const AppNav({super.key});

  @override
  State<AppNav> createState() => _AppNavState();
}

class _AppNavState extends State<AppNav> with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  final List<Widget> _pages = [
    const UserHome(),
    const ChatScreen(),
    const LocationScreen(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define a custom accent color for active states
    final accentColor = isDark ? AppPalette.gradient2 : AppPalette.error;

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            tabIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: CircleNavBar(
        activeIcons: [
          Icon(Icons.home, color: accentColor, size: 24),
          Icon(Icons.chat, color: accentColor, size: 24),
          Icon(Icons.location_on, color: accentColor, size: 24),
        ],
        inactiveIcons: [
          Text("Home",
              style: TextStyle(
                  color: isDark ? AppPalette.darkText.withOpacity(0.7) : AppPalette.lightText.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          Text("Chat",
              style: TextStyle(
                  color: isDark ? AppPalette.darkText.withOpacity(0.7) : AppPalette.lightText.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          Text("Location",
              style: TextStyle(
                  color: isDark ? AppPalette.darkText.withOpacity(0.7) : AppPalette.lightText.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
        gradient: LinearGradient(
          colors: [
            isDark ? AppPalette.darkGradientStart : AppPalette.lightGradientStart,
            isDark ? AppPalette.lightGradientStart : AppPalette.lightGradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        height: 65,
        circleWidth: 55,
        activeIndex: tabIndex,
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        padding: const EdgeInsets.only(left: 2, right: 2, bottom: 1, top: 8),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        shadowColor: AppPalette.gradient2.withOpacity(0.4), // Slightly darker shadow
        elevation: 8,
        color: isDark ? AppPalette.gradient2 : AppPalette.gradient1, // Dynamic base color
      ),
    );
  }
}