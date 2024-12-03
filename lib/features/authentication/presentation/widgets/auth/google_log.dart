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
    scopes: [
      'email',
      'profile',
      'openid',
    ],
    signInOption: SignInOption.standard,
    serverClientId:
        '837006381197-ntpeojnppdcu0g5j01enk4gm8spaimfm.apps.googleusercontent.com',
  );

  Future<void> _handleSignIn() async {
    try {
      print('\n=== Starting Google Sign In Process ===');
      print('1. Initiating sign out to ensure fresh sign-in...');
      await _googleSignIn.signOut();

      print('2. Attempting to sign in...');
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        print('Sign in cancelled by user');
        return;
      }

      print('\n3. Account Details:');
      print('Email: ${account.email}');
      print('Display Name: ${account.displayName}');
      print('ID: ${account.id}');

      print('\n4. Requesting authentication...');
      final GoogleSignInAuthentication auth = await account.authentication;

      print('\n5. Authentication tokens:');
      print('Access Token present: ${auth.accessToken != null}');
      print('ID Token present: ${auth.idToken != null}');

      // Always use ID token for backend authentication
      final String? token = auth.idToken;

      if (token == null) {
        print('\nERROR: Failed to obtain ID token');
        print('Access Token: ${auth.accessToken}');
        throw Exception('Failed to obtain ID token');
      }

      print('\n6. ID Token obtained successfully');
      print('Token length: ${token.length}');
      print('Token prefix: ${token.substring(0, 10)}...');

      if (!mounted) return;
      context.read<AuthBloc>().add(GoogleAuthEvent(accessToken: token));
    } catch (error) {
      print('\n=== Error Details ===');
      print('Error type: ${error.runtimeType}');
      print('Full error details: $error');
      print('Stack trace:');
      print(StackTrace.current);

      if (!mounted) return;

      String message = 'Authentication failed';
      if (error is PlatformException) {
        print('\nPlatform Exception Details:');
        print('Error code: ${error.code}');
        print('Error message: ${error.message}');
        print('Error details: ${error.details}');

        if (error.code == 'sign_in_failed') {
          message =
              'Google Sign In configuration error. Please check your setup.';
        } else {
          message = error.message ?? 'Google Sign In failed';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
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
