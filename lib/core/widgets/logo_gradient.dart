import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class LogoGradientText extends StatelessWidget {
  final double fontSize;

  final FontWeight fontWeight;

  const LogoGradientText({
    super.key,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return AppPalette.primaryGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        'FlareUp',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
        ),
      ),
    );
  }
}
