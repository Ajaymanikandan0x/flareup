import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<void> _handleSignIn() async {
    try {
      print('\n=== Starting Google Sign In Process ===');

      // Clear any existing sessions
      await _googleSignIn.signOut();

      print('\nAttempting to sign in...');

      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        print('\n=== Successfully Retrieved Google Account ===');
        final GoogleSignInAuthentication auth = await account.authentication;
        final String? accessToken = auth.accessToken;
        print('\n=== Access Token: $accessToken ===');

        if (accessToken != null) {
          if (!context.mounted) return;

          // Send access token to backend using AuthBloc
          context
              .read<AuthBloc>()
              .add(GoogleAuthEvent(accessToken: accessToken));
        } else {
          throw Exception('Failed to obtain access token');
        }
      } else {
        print('\n=== Sign In Cancelled by User ===');
      }
    } catch (error) {
      print('\n=== Error Details ===');
      print('Error Type: ${error.runtimeType}');
      print('Error Message: $error');

      String errorMessage = 'Google Sign In failed';
      if (error is PlatformException) {
        switch (error.code) {
          case 'network_error':
            errorMessage = 'Please check your internet connection';
            break;
          case 'sign_in_required':
            errorMessage = 'Please sign in to continue';
            break;
          case 'sign_in_canceled':
            errorMessage = 'Sign in was cancelled';
            break;
          default:
            errorMessage =
                'Please make sure Google Play Services is installed and updated';
        }
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GoogleAuthSuccess) {
          // Handle successful Google authentication
          Navigator.pushReplacementNamed(
              context, '/home'); // Or your desired route
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: ElevatedButton.icon(
        onPressed: _handleSignIn,
        icon: Image.asset(
          'assets/images/google/logo.png',
          height: 27,
          width: 27,
        ),
        label: Text(
          'Continue with Google',
          style: AppTextStyles.primaryTextTheme(fontSize: 17),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: AppPalette.white,
          backgroundColor: AppPalette.cardColor,
          minimumSize: const Size(340, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
