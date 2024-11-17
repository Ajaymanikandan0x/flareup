import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/text_theme.dart';

class AuthPromptText extends StatelessWidget {
  final String prefixText;
  final String suffixText;
  final void Function() onTap;

  const AuthPromptText({
    super.key,
    required this.prefixText,
    required this.suffixText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: prefixText,
        style: AppTextStyles.primaryTextTheme(),
        children: [
          TextSpan(
            text: suffixText,
            style: AppTextStyles.gradientText(),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
