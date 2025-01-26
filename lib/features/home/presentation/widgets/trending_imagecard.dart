import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/custom_image_wid.dart';
import '../../domain/entities/get_event_entite.dart';

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
    // Initialize responsive utilities
    Responsive.init(context);

    // Calculate responsive dimensions
    final cardWidth = isHorizontal ? Responsive.screenWidth * 0.85 : null;
    final cardHeight = Responsive.screenHeight * 0.25;
    final overlayHeight = cardHeight * 0.5;

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
              color: Color.fromRGBO(0, 0, 0, 0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Banner Image with Gradient Overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(Responsive.borderRadius),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: "$cloudinaryBaseUrl${event.bannerImage}.png",
                    height: cardHeight,
                    width: double.infinity,
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color.fromRGBO(0, 0, 0, 0.7),
                          ],
                          stops: const [0.3, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Overlay
            Positioned(
              bottom: Responsive.verticalPadding,
              left: Responsive.horizontalPadding,
              right: Responsive.horizontalPadding,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Responsive.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: overlayHeight,
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.horizontalPadding * 0.8,
                      vertical: Responsive.verticalPadding * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppPalette.darkCard.withAlpha(128)
                          : AppPalette.lightCard.withAlpha(128),
                      borderRadius:
                          BorderRadius.circular(Responsive.borderRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Title
                        Text(
                          event.title,
                          style: AppTextStyles.primaryTextTheme(
                            fontSize: Responsive.titleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Spacer(flex: 1),

                        // Location and Date Row
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildInfoRow(
                              Icons.location_on,
                              '${event.addressLine1}, ${event.city}',
                            ),
                            const SizedBox(height: 5),
                            _buildInfoRow(
                              Icons.calendar_today,
                              _formatDate(event.startDateTime),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Price Tag
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.horizontalPadding * 0.8,
                              vertical: Responsive.verticalPadding * 0.3,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppPalette.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                  Responsive.borderRadius),
                            ),
                            child: Text(
                              event.paymentRequired
                                  ? 'IDR ${_formatPrice(event.ticketPrice)}'
                                  : 'Free',
                              style: AppTextStyles.primaryTextTheme(
                                fontSize: Responsive.bodyFontSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: Responsive.bodyFontSize,
          color: AppPalette.gradient2,
        ),
        SizedBox(width: Responsive.horizontalPadding * 0.3),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.primaryTextTheme(
              fontSize: Responsive.bodyFontSize * 1,
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
