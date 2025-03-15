import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/custom_image_wid.dart';
import '../../../domain/entities/get_event_entite.dart';

class AllEventCard extends StatelessWidget {
  final GetAllEventEntities event;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const AllEventCard({
    super.key,
    required this.event,
    this.isHorizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    // Responsive dimensions
    final cardWidth = isHorizontal
        ? Responsive.screenWidth * (Responsive.isTablet ? 0.85 : 0.98)
        : Responsive.screenWidth * 0.85;
    final cardHeight =
        Responsive.screenHeight * (Responsive.isTablet ? 0.32 : 0.28);
    final overlayHeight = cardHeight * 0.5;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(
          horizontal: isHorizontal
              ? Responsive.horizontalPadding * 0.06
              : Responsive.horizontalPadding * 0.4,
          vertical: Responsive.verticalPadding * 0.1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.borderRadius * 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Responsive.borderRadius * 1.2),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              CustomImageWidget(
                imageUrl: "$cloudinaryBaseUrl${event.bannerImage}.png",
                height: cardHeight,
                width: cardWidth,
                fit: BoxFit.cover,
                errorWidget: Container(color: Colors.grey.shade300),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.65),
                    ],
                    stops: const [0.3, 0.7, 1.0],
                  ),
                ),
              ),
              // Content Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildContentOverlay(context, overlayHeight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentOverlay(BuildContext context, double overlayHeight) {
    final titleSize = Responsive.isTablet ? 20.0 : 18.0;
    final infoSize = Responsive.isTablet ? 14.0 : 12.0;

    return ClipRRect(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(Responsive.borderRadius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: overlayHeight,
          padding: EdgeInsets.all(Responsive.horizontalPadding * 0.75),
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withOpacity(0.2),
            border:
                Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                event.title,
                style: AppTextStyles.primaryTextTheme(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                semanticsLabel: event.title,
              ),
              // Location and Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    Icons.location_on_rounded,
                    '${event.addressLine1}, ${event.city}',
                    infoSize,
                  ),
                  SizedBox(height: Responsive.verticalPadding * 0.25),
                  _buildInfoRow(
                    Icons.calendar_today_rounded,
                    _formatDate(event.startDateTime),
                    infoSize,
                  ),
                ],
              ),
              // Price Tag
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.horizontalPadding * 0.75,
                    vertical: Responsive.verticalPadding * 0.25,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppPalette.primaryGradient,
                    borderRadius:
                        BorderRadius.circular(Responsive.borderRadius * 0.6),
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.gradient2.withOpacity(0.4),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
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
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, double fontSize) {
    return Row(
      children: [
        Icon(
          icon,
          size: fontSize + 2,
          color: Colors.white.withOpacity(0.9),
        ),
        SizedBox(width: Responsive.horizontalPadding * 0.5),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.primaryTextTheme(
              fontSize: fontSize,
              color: Colors.white.withOpacity(0.85),
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
