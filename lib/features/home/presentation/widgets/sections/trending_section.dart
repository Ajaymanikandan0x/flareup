import 'package:carousel_slider/carousel_slider.dart';
import 'package:flareup/features/home/presentation/widgets/cards/trending_imagecard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/routs.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../../domain/entities/get_event_entite.dart';
import '../../bloc/event_bloc.dart';
import '../../bloc/event_state.dart';
import '../shimmer/event_card_shimmer.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    return BlocBuilder<EventBloc, EventBlocState>(
      builder: (context, state) {
        return _buildTrendingSection(state, context);
      },
    );
  }

  Widget _buildTrendingSection(EventBlocState state, BuildContext context) {
    if (state is EventsLoaded) {
      final sortedEvents = List<GetAllEventEntities>.from(state.allEvents)
        ..sort(
            (a, b) => b.currentParticipants.compareTo(a.currentParticipants));

      final trendingEvents = sortedEvents.take(5).toList();

      if (trendingEvents.isEmpty) {
        return const SizedBox.shrink();
      }

      // Calculate responsive dimensions
      final sectionPadding = EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding,
        vertical: Responsive.verticalPadding * 0.5,
      );
      final titleFontSize = Responsive.isTablet
          ? Responsive.titleFontSize * 1.2
          : Responsive.titleFontSize;
      final iconSize = Responsive.iconSize;
      final cardHeight =
          Responsive.screenHeight * (Responsive.isTablet ? 0.45 : 0.28);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: sectionPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Trending Events',
                      style: AppTextStyles.primaryTextTheme().copyWith(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: Responsive.spacingWidth * 0.4),
                    Icon(
                      Icons.trending_up,
                      size: iconSize,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRouts.category,
                    );
                  },
                  child: Text(
                    'See all',
                    style: AppTextStyles.primaryTextTheme().copyWith(
                      fontSize: Responsive.bodyFontSize,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CarouselSlider.builder(
            itemCount: trendingEvents.length,
            options: CarouselOptions(
              height: cardHeight,
              aspectRatio: 16 / 9,
              viewportFraction: Responsive.isTablet ? 0.8 : 0.85,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              scrollDirection: Axis.horizontal,
              padEnds: true,
            ),
            itemBuilder: (context, index, realIndex) {
              final event = trendingEvents[index];
              return Stack(
                children: [
                  TrendingImageCard(
                    event: event,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouts.eventLogo,
                      arguments: event,
                    ),
                    isHorizontal: true,
                  ),
                  Positioned(
                    top: Responsive.verticalPadding,
                    right: Responsive.horizontalPadding,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.horizontalPadding * 0.4,
                        vertical: Responsive.verticalPadding * 0.2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                          Responsive.borderRadius * 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people,
                            size: Responsive.bodyFontSize,
                            color: Colors.white,
                          ),
                          SizedBox(width: Responsive.spacingWidth * 0.2),
                          Text(
                            '${event.currentParticipants}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.bodyFontSize * 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      );
    }

    // Loading state remains the same but with responsive dimensions
    if (state is EventLoading) {
      return _buildLoadingState();
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding,
            vertical: Responsive.verticalPadding * 0.5,
          ),
          child: ShimmerLoading(
            isLoading: true,
            child: Container(
              height:
                  Responsive.screenHeight * (Responsive.isTablet ? 0.45 : 0.4),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Responsive.borderRadius),
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
