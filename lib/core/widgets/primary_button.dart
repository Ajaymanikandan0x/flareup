import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/widgets/text_theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final IconData? iconData;
  const PrimaryButton(
      {super.key,
      required this.onTap,
      required this.text,
      this.width = 20,
      this.height = 15,
      this.elevation = 5,
      this.borderRadius = 15,
      this.fontSize,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius!),
          gradient: AppPalette.myGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
            child: Text(
          text,
          style: textTheme(fontSize: fontSize),
        )),
      ),
    );
  }
}
