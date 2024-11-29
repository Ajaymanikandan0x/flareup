import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Avatar extends StatelessWidget {
  final String? imgUrl;
  final double? radius;
  final Color? backgroundColor;
  final double? iconSize;

  const Avatar(
      {super.key,
      this.imgUrl,
      this.radius,
      this.backgroundColor,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius ?? 24,
        backgroundColor: backgroundColor ?? AppPalette.hintTextColor,
        child: imgUrl != null
            ? ClipOval(
                child: Image.network(
                  imgUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return FaIcon(
                      FontAwesomeIcons.userLarge,
                      size: iconSize,
                    );
                  },
                ),
              )
            : FaIcon(
                FontAwesomeIcons.userLarge,
                size: iconSize,
              ));
  }
}
