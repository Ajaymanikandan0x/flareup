import 'package:cached_network_image/cached_network_image.dart';
import 'package:flareup/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Avatar extends StatelessWidget {
  final String? imgUrl;
  final double? radius;
  final Color? backgroundColor;
  final double? iconSize;

  const Avatar({
    super.key,
    this.imgUrl,
    this.radius,
    this.backgroundColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    
    // Calculate responsive radius based on screen width
    final responsiveRadius = radius ?? (screenSize.width * 0.06);
    
    // Calculate responsive icon size based on radius
    final responsiveIconSize = iconSize ?? (responsiveRadius * 0.8);

    return LayoutBuilder(
      builder: (context, constraints) {
        return CircleAvatar(
          radius: responsiveRadius,
          backgroundColor: backgroundColor ?? (Theme.of(context).brightness == Brightness.dark 
                ? AppPalette.darkCard 
                : AppPalette.lightCard),
          child: imgUrl != null && imgUrl!.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imgUrl!,
                    width: responsiveRadius * 2,
                    height: responsiveRadius * 2,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) {
                      debugPrint('Error loading image: $error');
                      return FaIcon(
                        FontAwesomeIcons.userLarge,
                        size: responsiveIconSize,
                        color: Theme.of(context).brightness == Brightness.dark 
                ? AppPalette.darkCard 
                : AppPalette.lightCard,
                      );
                    },
                  ),
                )
              : FaIcon(
                  FontAwesomeIcons.userLarge,
                  size: responsiveIconSize,
                  color: Theme.of(context).brightness == Brightness.dark 
                ? AppPalette.darkCard 
                : AppPalette.lightCard,
                ),
        );
      },
    );
  }
}
