import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/widgets/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print('User signed in: ${account.displayName}');
      }
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _handleSignIn,
      icon: Image.asset(
        'assets/images/google/logo.png',
        height: 27,
        width: 27,
      ),
      label: Text(
        'Login with Google',
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
    );
  }
}
