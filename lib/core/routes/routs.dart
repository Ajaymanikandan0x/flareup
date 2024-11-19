import 'package:flareup/features/authentication/presentation/screens/otp.dart';
import 'package:flareup/features/authentication/presentation/screens/sign_in.dart';
import 'package:flareup/features/authentication/presentation/screens/sign_up.dart';
import 'package:flareup/features/profile/presentation/screens/profile.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/screens/logo.dart';
import '../../features/authentication/presentation/screens/onboard_screen.dart';
import '../../features/home/presentation/screens/home.dart';

class AppRouts {
  static const logo = '/';
  static const onBoard = '/onBoard';
  static const home = '/home';
  static const signIn = '/signIn';
  static const signUp = '/signUp';
  static const profile = '/profile';
  static const otpScreen = '/otpScreen';

  static final Map<String, WidgetBuilder> routs = {
    logo: (_) => const Logo(),
    onBoard: (_) => const OnBoardingScreen(),
    signIn: (_) => SignIn(),
    signUp: (_) => SignUp(),
    home: (_) => const Home(),
    profile: (_) => const Profile(),
    otpScreen:(_)=> const OtpScreen() ,
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final builder = routs[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }
    return null;
  }
}
