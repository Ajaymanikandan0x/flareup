import 'package:cached_network_image/cached_network_image.dart';
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
      child: imgUrl != null && imgUrl!.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: imgUrl!,
                width: (radius ?? 24) * 2,
                height: (radius ?? 24) * 2,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) {
                  print('Error loading image: $error');
                  return FaIcon(
                    FontAwesomeIcons.userLarge,
                    size: iconSize,
                    color: AppPalette.white,
                  );
                },
              ),
            )
          : FaIcon(
              FontAwesomeIcons.userLarge,
              size: iconSize,
              color: AppPalette.white,
            ),
    );
  }
}
