import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/routes/routs.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../bloc/event_bloc.dart';
import '../../bloc/event_state.dart';
import '../event_card_empty_state.dart';
import '../eventcard.dart';
import '../shimmer/event_card_shimmer.dart';

class NearbySection extends StatelessWidget {
  const NearbySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventBlocState>(
      builder: (context, state) {
        return _buildNearbySection(state);
      },
    );
  }

  Widget _buildNearbySection(EventBlocState state) {
    if (state is EventsLoaded) {
      if (state.nearbyEvents.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding,
            vertical: Responsive.verticalPadding * 0.5,
          ),
          child: const EventCardEmptyState(
            message: 'No events found nearby',
            icon: Icons.location_off,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding,
              vertical: Responsive.verticalPadding * 0.5,
            ),
            child: Row(
              children: [
                Text(
                  'Nearby Events',
                  style: AppTextStyles.primaryTextTheme().copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.location_on,
                  size: 24,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: state.nearbyEvents.length,
              itemBuilder: (context, index) {
                final event = state.nearbyEvents[index];
                return Stack(
                  children: [
                    EventCard(
                      event: event,
                      onTap: () => AppRouts.eventLogo,
                      isHorizontal: true,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(0, 0, 0, 2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.directions_walk,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_calculateDistance(event.latitude, event.longitude, context)} km',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
          ),
        ],
      );
    }

    if (state is EventLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding,
              vertical: Responsive.verticalPadding * 0.5,
            ),
            child: const ShimmerLoading(
              isLoading: true,
              child: EventCardShimmer(isHorizontal: true),
            ),
          ),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const EventCardShimmer(isHorizontal: true);
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  String _calculateDistance(
      double eventLat, double eventLng, BuildContext context) {
    try {
      final currentPosition = context.read<EventBloc>().state;
      if (currentPosition is EventsLoaded &&
          currentPosition.nearbyEvents.isNotEmpty) {
        final distance = Geolocator.distanceBetween(
          currentPosition.nearbyEvents.first.latitude,
          currentPosition.nearbyEvents.first.longitude,
          eventLat,
          eventLng,
        );
        return (distance / 1000)
            .toStringAsFixed(1); // Convert to km and round to 1 decimal
      }
    } catch (e) {
      debugPrint('Error calculating distance: $e');
    }
    return '?';
  }
}
