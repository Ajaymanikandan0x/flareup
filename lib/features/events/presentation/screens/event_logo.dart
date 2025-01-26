import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flareup/core/widgets/primary_button.dart';
import 'package:flareup/features/events/presentation/widgets/loading/image_shimmer_loading.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/custom_image_wid.dart';
import '../widgets/member_avatar_group.dart';
import 'dummy_logo.dart';

class EventLogoScreen extends StatelessWidget {
  const EventLogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    // Calculate responsive dimensions
    final contentPadding = EdgeInsets.symmetric(
      horizontal: Responsive.horizontalPadding,
      vertical: Responsive.verticalPadding,
    );
    final dateSize =
        Responsive.bodyFontSize * (Responsive.isTablet ? 2.0 : 1.7);
    final titleSize =
        Responsive.titleFontSize * (Responsive.isTablet ? 3.5 : 3.0);
    final locationSize =
        Responsive.bodyFontSize * (Responsive.isTablet ? 2.5 : 2.0);
    final locationIconSize = Responsive.isTablet ? 36.0 : 30.0;
    final memberTextSize =
        Responsive.bodyFontSize * (Responsive.isTablet ? 1.8 : 1.6);

    // Using dummy data for now
    final event = DummyEvent.sampleEvent;

    /* Commented bloc implementation for future use
    return BlocBuilder<SingleEventBloc, SingleEventState>(
      builder: (context, state) {
        if (state is SingleEventLoading) {
          return const EventLogoShimmer();
        }
        // ... rest of the bloc implementation
    });
    */

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Gradient Overlay
          CustomImageWidget(
            imageUrl: event.bannerImage,
            placeholder: ImageShimmerLoading(),
          ),

          // Enhanced gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.5),
                  Color.fromRGBO(0, 0, 0, 0.8),
                  Color.fromRGBO(0, 0, 0, 0.95)
                ],
                stops: const [0.2, 0.7, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: contentPadding,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Spacer with responsive height
                            SizedBox(height: constraints.maxHeight * 0.3),

                            // Event Date
                            Text(
                              _formatDate(event.startDateTime),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: dateSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: Responsive.spacingHeight * 0.5),

                            // Event Title with Hero animation
                            Hero(
                              tag: 'event_title_${event.id}',
                              child: Text(
                                event.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ),

                            SizedBox(height: Responsive.spacingHeight),

                            // Location with responsive layout
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: locationIconSize,
                                ),
                                SizedBox(width: Responsive.spacingWidth * 0.5),
                                Expanded(
                                  child: Text(
                                    '${event.addressLine1}, ${event.city}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: locationSize,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: Responsive.spacingHeight * 1.5),

                            // Members section with enhanced layout
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Members',
                                  style:
                                      AppTextStyles.primaryTextTheme().copyWith(
                                    color: Colors.white,
                                    fontSize: memberTextSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                    height: Responsive.spacingHeight * 0.5),
                                MemberAvatarGroup(
                                  memberCount: event.participantCount,
                                  maxDisplayed: Responsive.isTablet ? 4 : 3,
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Buy Ticket Button with responsive size
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: PrimaryButton(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRouts.eventHome);
                                },
                                text: 'BUY TICKET',
                                width: Responsive.screenWidth * 0.85,
                                height: Responsive.buttonHeight * 1.1,
                              ),
                            ),
                            SizedBox(height: Responsive.spacingHeight),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
