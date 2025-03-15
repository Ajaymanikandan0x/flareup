import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/custom_image_wid.dart';
import '../../../domain/entities/get_event_entite.dart';

class LocationEventCard extends StatelessWidget {
  final GetAllEventEntities event;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const LocationEventCard({
    super.key,
    required this.event,
    this.isHorizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    final cardWidth =
        isHorizontal ? Responsive.screenWidth * 0.75 : double.infinity;
    final cardHeight = Responsive.screenHeight * 0.18;
    final imageSize = cardHeight;
    final contentPadding = Responsive.horizontalPadding * 0.8;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding * 0.5,
          vertical: 0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side - Image
            SizedBox(
              width: imageSize,
              height: imageSize,
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(Responsive.borderRadius),
                ),
                child: CustomImageWidget(
                  imageUrl: "$cloudinaryBaseUrl${event.bannerImage}",
                  fit: BoxFit.cover,
                  placeholder: _buildPlaceholderImage(imageSize),
                  errorWidget: _buildErrorImage(imageSize),
                ),
              ),
            ),

            // Right side - Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Capacity info
                    SizedBox(
                      height: Responsive.spacingHeight * 0.4,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.horizontalPadding * 0.3,
                          vertical: Responsive.verticalPadding * 0.15,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.gradient2.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                              Responsive.borderRadius * 0.4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: Responsive.iconSize * 0.7,
                              color: AppPalette.gradient2,
                            ),
                            SizedBox(width: Responsive.spacingWidth * 0.15),
                            Text(
                              'Capacity: ${event.participantCapacity}',
                              style: TextStyle(
                                fontSize: Responsive.bodyFontSize * 0.9,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.darkCard,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Title
                    Flexible(
                      child: Text(
                        event.title,
                        style: TextStyle(
                          fontSize: Responsive.subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.darkCard,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: Responsive.iconSize * 0.7,
                          color: AppPalette.gradient2,
                        ),
                        SizedBox(width: Responsive.spacingWidth * 0.15),
                        Expanded(
                          child: Text(
                            '${event.addressLine1}, ${event.city}',
                            style: TextStyle(
                              fontSize: Responsive.bodyFontSize * 0.9,
                              color: AppPalette.darkCard,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Price
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.horizontalPadding * 0.3,
                          vertical: Responsive.verticalPadding * 0.15,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.payment.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                              Responsive.borderRadius * 0.4),
                        ),
                        child: Text(
                          event.paymentRequired
                              ? 'Price: ${_formatPrice(event.ticketPrice)}'
                              : 'Free',
                          style: TextStyle(
                            fontSize: Responsive.bodyFontSize * 0.9,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.payment,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(double height) {
    return Container(
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined,
              size: height * 0.25, color: Colors.grey[400]),
          SizedBox(height: Responsive.spacingHeight * 0.5),
          Text(
            'No Image Available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: Responsive.bodyFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorImage(double height) {
    return Container(
      height: height,
      color: AppPalette.gradient2.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: height * 0.25,
            color: Colors.grey[400],
          ),
          SizedBox(height: Responsive.spacingHeight * 0.5),
          Text(
            'Failed to load image',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: Responsive.bodyFontSize,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return '${price.toInt()} - ${(price + 600).toInt()}';
  }
}
