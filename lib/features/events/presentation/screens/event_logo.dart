import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../bloc/single_event_bloc.dart';

import '../widgets/loading/logo_screen_shimmer.dart';
import '../widgets/logo_error.dart';
import '../widgets/member_avatar_group.dart';

class EventLogoScreen extends StatelessWidget {
  const EventLogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return BlocBuilder<SingleEventBloc, SingleEventState>(
      builder: (context, state) {
        if (state is SingleEventLoading) {
          return const EventLogoShimmer();
        }

        if (state is SingleEventLoaded) {
          final event = state.event;
          if (event.bannerImage.isEmpty) {
            return const EventLogoErrorWidget(
              message: 'Event image not available',
            );
          }

          return Scaffold(
            body: Stack(
              children: [
                // Background Image with Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(event.bannerImage),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(Responsive.horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),

                        // Date
                        Text(
                          _formatDate(event.startDateTime),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.bodyFontSize,
                          ),
                        ),

                        const Spacer(),

                        // Event Title
                        Text(
                          event.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.titleFontSize * 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: Responsive.spacingHeight),

                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            SizedBox(width: Responsive.spacingWidth * 0.5),
                            Text(
                              '${event.addressLine1}, ${event.city}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.bodyFontSize,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Responsive.spacingHeight * 2),

                        // Members Going
                        Row(
                          children: [
                            const MemberAvatarGroup(),
                            SizedBox(width: Responsive.spacingWidth),
                            Text(
                              'Going',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.bodyFontSize,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Responsive.spacingHeight * 2),

                        // Buy Ticket Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Implement ticket purchase
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: Responsive.buttonHeight * 0.3,
                              ),
                              backgroundColor: AppPalette.gradient2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Responsive.borderRadius,
                                ),
                              ),
                            ),
                            child: Text(
                              'BUY TICKET',
                              style: TextStyle(
                                fontSize: Responsive.screenWidth,
                                fontWeight: FontWeight.bold,
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
          );
        }

        if (state is SingleEventError) {
          return EventLogoErrorWidget(
            message: state.message,
            onRetry: () {
              // Add retry functionality if needed
              // context.read<SingleEventBloc>().add(LoadEventEvent(eventId));
            },
          );
        }

        return const EventLogoErrorWidget(
          message: 'No event selected. Please select an event to view details.',
        );
      },
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
