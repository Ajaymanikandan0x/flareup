import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/theme/app_palette.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/custom_image_wid.dart';
import '../../../domain/entities/get_event_entite.dart';

class EventCard extends StatelessWidget {
  final GetAllEventEntities event;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.isHorizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    // Calculate responsive dimensions
    final cardWidth =
        isHorizontal ? Responsive.screenWidth * 0.75 : double.infinity;
    final imageHeight = Responsive.screenHeight * 0.22;
    final titleSize = Responsive.isTablet ? 22.0 : 18.0;
    final chipSize = Responsive.isTablet ? 14.0 : 12.0;
    final iconSize = Responsive.isTablet ? 20.0 : 16.0;
    final infoTextSize = Responsive.isTablet ? 16.0 : 14.0;
    final statusBadgeSize = Responsive.isTablet ? 14.0 : 12.0;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Responsive.borderRadius),
        ),
        margin: EdgeInsets.only(
          right: isHorizontal ? Responsive.horizontalPadding : 0,
          bottom: isHorizontal ? 0 : Responsive.verticalPadding,
          left: isHorizontal ? 0 : Responsive.horizontalPadding,
          top: isHorizontal ? 0 : Responsive.verticalPadding,
        ),
        child: Container(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Responsive.borderRadius),
                    ),
                    child: CustomImageWidget(
                      imageUrl: "$cloudinaryBaseUrl${event.bannerImage}",
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: _buildPlaceholderImage(imageHeight),
                      errorWidget: _buildErrorImage(imageHeight),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Responsive.borderRadius),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8)
                          ],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: Responsive.verticalPadding,
                    left: Responsive.horizontalPadding,
                    right: Responsive.horizontalPadding,
                    child: Text(
                      event.title,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.darkText,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Positioned(
                    top: Responsive.verticalPadding,
                    right: Responsive.horizontalPadding,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.horizontalPadding * 0.8,
                        vertical: Responsive.verticalPadding * 0.5,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(event.status),
                        borderRadius: BorderRadius.circular(
                            Responsive.borderRadius * 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        event.status,
                        style: TextStyle(
                          color: AppPalette.darkText,
                          fontSize: statusBadgeSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(Responsive.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: Responsive.spacingWidth * 0.5,
                      children: [
                        _buildChip(event.category, chipSize),
                        _buildChip(event.type, chipSize),
                      ],
                    ),
                    SizedBox(height: Responsive.spacingHeight),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      text:
                          '${_formatDate(event.startDateTime)} - ${_formatDate(event.endDateTime)}',
                      context: context,
                      color: AppPalette.gradient2,
                      iconSize: iconSize,
                      textSize: infoTextSize,
                    ),
                    SizedBox(height: Responsive.spacingHeight * 0.5),
                    _buildInfoRow(
                      icon: Icons.location_on,
                      text: '${event.addressLine1}, ${event.city}',
                      context: context,
                      color: AppPalette.gradient2,
                      iconSize: iconSize,
                      textSize: infoTextSize,
                    ),
                    SizedBox(height: Responsive.spacingHeight),
                    _buildFooterRow(context, iconSize, infoTextSize),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _buildChip(String label, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding * 0.5,
        vertical: Responsive.verticalPadding * 0.3,
      ),
      decoration: BoxDecoration(
        gradient: AppPalette.primaryGradient,
        borderRadius: BorderRadius.circular(Responsive.borderRadius * 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required BuildContext context,
    required Color color,
    required double iconSize,
    required double textSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(Responsive.horizontalPadding * 0.5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(Responsive.borderRadius * 0.4),
          ),
          child: Icon(icon, size: iconSize, color: color),
        ),
        SizedBox(width: Responsive.spacingWidth * 0.5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppPalette.darkText,
              fontSize: textSize,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterRow(
      BuildContext context, double iconSize, double textSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding * 0.4,
              vertical: Responsive.verticalPadding * 0.3,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(Responsive.borderRadius * 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people, size: iconSize, color: AppPalette.gradient2),
                SizedBox(width: Responsive.spacingWidth * 0.2),
                Flexible(
                  child: Text(
                    '${event.participantCapacity} spots',
                    style: TextStyle(
                      color: AppPalette.darkText,
                      fontSize: textSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: Responsive.spacingWidth),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding * 0.4,
              vertical: Responsive.verticalPadding * 0.3,
            ),
            decoration: BoxDecoration(
              color: AppPalette.payment.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(Responsive.borderRadius * 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.attach_money,
                    size: iconSize, color: AppPalette.payment),
                SizedBox(width: Responsive.spacingWidth * 0.2),
                Flexible(
                  child: Text(
                    event.paymentRequired
                        ? 'IDR ${_formatPrice(event.ticketPrice)}'
                        : 'Free',
                    style: TextStyle(
                      color: AppPalette.payment,
                      fontSize: textSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppPalette.active;
      case 'cancelled':
        return AppPalette.cancelled;
      case 'pending':
        return AppPalette.pending;
      case 'draft':
        return AppPalette.draft;
      default:
        return AppPalette.draft;
    }
  }
}
