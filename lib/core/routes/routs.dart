import 'package:flareup/features/authentication/presentation/screens/otp.dart';
import 'package:flareup/features/authentication/presentation/screens/sign_in.dart';
import 'package:flareup/features/authentication/presentation/screens/sign_up.dart';
import 'package:flareup/features/profile/presentation/screens/profile.dart';
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/screens/forgot_password.dart';
import '../../features/authentication/presentation/screens/logo.dart';
import '../../features/authentication/presentation/screens/onboard_screen.dart';
import '../../features/authentication/presentation/screens/reset_password.dart';
import '../../features/chat/presentation/screens/chat.dart';
import '../../features/events/presentation/screens/event_home.dart';
import '../../features/events/presentation/screens/event_logo.dart';
import '../../features/events/presentation/screens/ticket_count_screen.dart';
import '../../features/home/presentation/screens/category/category.dart';
import '../../features/home/presentation/screens/category/event_list.dart';
import '../../features/home/presentation/screens/category/sub_category.dart';

import '../../features/home/presentation/screens/search_result.dart';
import '../../features/location/presentation/screens/location.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/profile/presentation/screens/edit.dart';
import '../widgets/bottom_navbar.dart';

class AppRouts {
  static const logo = '/';
  static const onBoard = '/onBoard';

  static const signIn = '/signIn';
  static const signUp = '/signUp';
  static const profile = '/profile';
  static const otpScreen = '/otpScreen';
  static const editProf = '/editProfile';
  static const forgotPassword = '/forgotPassword';
  static const resetPassword = '/resetPassword';
  static const eventLogo = '/eventLogo';
  static const category = '/categoryScreen';
  static const subCategories = '/subCategories';
  static const eventList = '/eventList';
  static const eventHome = '/eventHome';
  static const location = '/locationScreen';
  static const searchResults = '/searchResults';
  static const chat = '/chat';
  static const navBar = '/navBar';
  static const ticketCount = '/ticketCount';
  static const paymentScreen = '/paymentScreen';
  static final Map<String, Widget Function(BuildContext)> routs = {
    logo: (_) => const Logo(),
    onBoard: (_) => const OnBoardingScreen(),
    signIn: (_) => const SignIn(),
    signUp: (_) => SignUp(),
    profile: (_) => const Profile(),
    otpScreen: (_) => const OtpScreen(),
    editProf: (_) => const EditProfile(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    resetPassword: (_) => const ResetPasswordScreen(),
    eventLogo: (_) => const EventLogoScreen(),
    category: (_) => const CategoryScreen(),
    subCategories: (_) => const SubCategoryScreen(),
    eventList: (_) => const EventListScreen(),
    eventHome: (_) => const EventHome(),
    location: (_) => LocationScreen(),
    searchResults: (_) => const SearchResults(),
    chat: (_) => const ChatScreen(),
    navBar: (_) => const AppNav(),
    ticketCount: (_) => const TicketCountScreen(),
    paymentScreen: (_) => const PaymentScreen(),
  };

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final builder = routs[settings.name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: (context) => builder(context),
        settings: settings,
      );
    }
    throw Exception('Route not found: ${settings.name}');
  }
}
