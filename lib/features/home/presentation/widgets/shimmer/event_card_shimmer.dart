import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/shimmer_loading.dart';


class EventCardShimmer extends StatelessWidget {
  final bool isHorizontal;

  const EventCardShimmer({
    super.key,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: true,
      child: Container(
        width: isHorizontal ? 300 : double.infinity,
        margin: EdgeInsets.all(Responsive.horizontalPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Responsive.borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Flexible(
              child: Container(
                height: isHorizontal ? 200 : 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Responsive.borderRadius),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(Responsive.horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date shimmer
                  Container(
                    width: 80,
                    height: Responsive.bodyFontSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: Responsive.spacingHeight),
                  
                  // Title shimmer
                  Container(
                    width: double.infinity,
                    height: Responsive.titleFontSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: Responsive.spacingHeight * 0.5),
                  
                  // Location shimmer
                  Container(
                    width: 150,
                    height: Responsive.bodyFontSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}