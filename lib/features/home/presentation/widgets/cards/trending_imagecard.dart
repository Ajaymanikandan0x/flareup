import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/custom_image_wid.dart';
import '../../../domain/entities/get_event_entite.dart';

class TrendingImageCard extends StatelessWidget {
  final GetAllEventEntities event;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const TrendingImageCard({
    super.key,
    required this.event,
    this.isHorizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    // Enhanced responsive dimensions
    final cardWidth = isHorizontal
        ? Responsive.screenWidth * (Responsive.isTablet ? 0.7 : 0.85)
        : Responsive.screenWidth * 0.85;
    final cardHeight =
        Responsive.screenHeight * (Responsive.isTablet ? 0.3 : 0.25);
    final overlayHeight = cardHeight * 0.55;
    final contentPadding = EdgeInsets.symmetric(
      horizontal: Responsive.horizontalPadding * 0.8,
      vertical: Responsive.verticalPadding * 0.6,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.only(
          right: isHorizontal ? Responsive.horizontalPadding : 0,
          bottom: isHorizontal ? 0 : Responsive.verticalPadding,
          left: isHorizontal ? 0 : Responsive.horizontalPadding,
          top: isHorizontal ? 0 : Responsive.verticalPadding * 0.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Enhanced Banner Image with Gradient Overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(Responsive.borderRadius),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: "$cloudinaryBaseUrl${event.bannerImage}.png",
                    height: cardHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Enhanced gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.2, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced Content Overlay
            Positioned(
              bottom: Responsive.verticalPadding,
              left: Responsive.horizontalPadding,
              right: Responsive.horizontalPadding,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Responsive.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    height: overlayHeight,
                    padding: contentPadding,
                    decoration: BoxDecoration(
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? AppPalette.darkCard
                              : AppPalette.lightCard)
                          .withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(Responsive.borderRadius),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                    child: _buildContentOverlay(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentOverlay(BuildContext context) {
    final titleSize = Responsive.isTablet
        ? Responsive.titleFontSize * 1.2
        : Responsive.titleFontSize;
    final infoSize = Responsive.isTablet
        ? Responsive.bodyFontSize * 1.1
        : Responsive.bodyFontSize;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event Title with enhanced styling
        Text(
          event.title,
          style: AppTextStyles.primaryTextTheme(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const Spacer(flex: 1),

        // Enhanced Location and Date information
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow(
              Icons.location_on_rounded,
              '${event.addressLine1}, ${event.city}',
              infoSize,
            ),
            SizedBox(height: Responsive.verticalPadding * 0.3),
            _buildInfoRow(
              Icons.calendar_today_rounded,
              _formatDate(event.startDateTime),
              infoSize,
            ),
          ],
        ),

        const Spacer(),

        // Enhanced Price Tag
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding * 0.8,
              vertical: Responsive.verticalPadding * 0.3,
            ),
            decoration: BoxDecoration(
              gradient: AppPalette.primaryGradient,
              borderRadius:
                  BorderRadius.circular(Responsive.borderRadius * 0.8),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.gradient2.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              event.paymentRequired
                  ? 'IDR ${_formatPrice(event.ticketPrice)}'
                  : 'Free',
              style: AppTextStyles.primaryTextTheme(
                fontSize: infoSize,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: fontSize,
          color: AppPalette.gradient2,
        ),
        SizedBox(width: Responsive.horizontalPadding * 0.3),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.primaryTextTheme(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
