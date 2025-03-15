import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flareup/core/widgets/primary_button.dart';
import 'package:flareup/features/events/presentation/widgets/loading/image_shimmer_loading.dart';
import 'package:flareup/features/events/presentation/widgets/logo_error.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/custom_image_wid.dart';
import '../../../home/domain/entities/get_event_entite.dart';

import '../widgets/member_avatar_group.dart';
import '../bloc/single_event_bloc.dart';

class EventLogoScreen extends StatefulWidget {
  const EventLogoScreen({super.key});

  @override
  State<EventLogoScreen> createState() => _EventLogoScreenState();
}

class _EventLogoScreenState extends State<EventLogoScreen> {
  late GetAllEventEntities event;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      event = ModalRoute.of(context)!.settings.arguments as GetAllEventEntities;
      context.read<SingleEventBloc>().add(SelectEvent(event));
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleEventBloc, SingleEventState>(
      builder: (context, state) {
        if (state is SingleEventLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is SingleEventError) {
          return Scaffold(
            body: EventLogoErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<SingleEventBloc>().add(SelectEvent(event));
              },
            ),
          );
        }

        if (state is SingleEventLoaded) {
          return _EventContent(event: state.event);
        }

        return const Scaffold(
          body: Center(child: Text('No event data available')),
        );
      },
    );
  }
}

class _EventContent extends StatelessWidget {
  final GetAllEventEntities event;

  const _EventContent({required this.event});

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

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with Gradient Overlay
          CustomImageWidget(
            imageUrl: "$cloudinaryBaseUrl${event.bannerImage}",
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

                            // Location
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
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: Responsive.spacingHeight * 1.5),

                            // Members section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Members',
                                        style: AppTextStyles.primaryTextTheme()
                                            .copyWith(
                                          color: Colors.white,
                                          fontSize: memberTextSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '${event.keyParticipants.length}/${event.participantCapacity}',
                                      style: AppTextStyles.primaryTextTheme()
                                          .copyWith(
                                        color: Colors.white70,
                                        fontSize: memberTextSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: Responsive.spacingHeight * 0.5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MemberAvatarGroup(
                                        memberCount:
                                            event.keyParticipants.length,
                                        maxDisplayed:
                                            Responsive.isTablet ? 4 : 3,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white54,
                                      size: Responsive.isTablet ? 24 : 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Buy Ticket Button
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: PrimaryButton(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouts.eventHome,
                                    arguments: event,
                                  );
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
