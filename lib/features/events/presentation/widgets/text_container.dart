import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String text;
  final Color? color;
  const TextContainer({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color ?? AppPalette.darkCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }
}
