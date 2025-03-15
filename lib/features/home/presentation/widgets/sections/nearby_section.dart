import 'dart:async';

import 'package:flareup/features/home/presentation/bloc/event_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/routes/routs.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utils/responsive_utils.dart';

import '../../bloc/event_bloc.dart';
import '../../bloc/event_state.dart';
import '../cards/locaton_event_card.dart';

import '../empty_states/nearby_empty_state.dart';

class NearbySection extends StatefulWidget {
  const NearbySection({super.key});

  @override
  State<NearbySection> createState() => _NearbySectionState();
}

class _NearbySectionState extends State<NearbySection> {
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Location services are disabled. Please enable them in settings.'),
            ),
          );
        }
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Location permission denied. Distance calculation unavailable.'),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Location permissions permanently denied. Please enable in app settings.'),
            ),
          );
        }
        return;
      }

      // Get position with timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Location request timed out');
        },
      );

      if (mounted) {
        setState(() {
          _userPosition = position;
        });

        // Fetch nearby events
        context.read<EventBloc>().add(FetchNearbyEventsEvent(
              latitude: position.latitude,
              longitude: position.longitude,
            ));
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: ${e.toString()}'),
          ),
        );
      }
    }
  }

  String _calculateDistance(double eventLat, double eventLng) {
    if (_userPosition == null) {
      debugPrint('Distance calculation failed: User position is null');
      return '?';
    }

    if (eventLat == 0 && eventLng == 0) {
      debugPrint(
          'Distance calculation failed: Invalid event coordinates (0,0)');
      return '?';
    }

    try {
      debugPrint(
          'Calculating distance from: (${_userPosition!.latitude}, ${_userPosition!.longitude}) to ($eventLat, $eventLng)');

      final distance = Geolocator.distanceBetween(
        _userPosition!.latitude,
        _userPosition!.longitude,
        eventLat,
        eventLng,
      );

      debugPrint('Raw distance calculated: $distance meters');

      if (distance < 1000) {
        return '${distance.round()}m';
      } else {
        final km = distance / 1000;
        if (km >= 100) {
          return '${km.round()}km';
        } else {
          return '${km.toStringAsFixed(1)}km';
        }
      }
    } catch (e) {
      debugPrint('Error calculating distance: $e');
      return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    // Calculate responsive dimensions
    final titleSize = Responsive.isTablet ? 28.0 : 24.0;
    final iconSize = Responsive.isTablet ? 28.0 : 24.0;
    final cardHeight = Responsive.screenHeight * 0.20;
    final distanceChipPadding = EdgeInsets.symmetric(
      horizontal: Responsive.horizontalPadding * 0.4,
      vertical: Responsive.verticalPadding * 0.2,
    );
    final distanceFontSize = Responsive.isTablet ? 14.0 : 12.0;
    final distanceIconSize = Responsive.isTablet ? 20.0 : 16.0;

    return BlocBuilder<EventBloc, EventBlocState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section always visible
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding,
                vertical: Responsive.verticalPadding * 0.9,
              ),
              child: Row(
                children: [
                  Text(
                    'Nearby Events',
                    style: AppTextStyles.primaryTextTheme().copyWith(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: Responsive.spacingWidth * 0.6),
                  Icon(Icons.location_on, size: iconSize),
                ],
              ),
            ),
            // Content section
            if (state is EventLoading)
              Center(
                child: CircularProgressIndicator(
                  strokeWidth: Responsive.isTablet ? 3.0 : 2.0,
                ),
              )
            else if (state is EventsLoaded)
              if (state.nearbyEvents.isEmpty)
                NearbyEmptyState(onSearchDestinations: () async {
                  try {
                    // Check location permission
                    final permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      final requested = await Geolocator.requestPermission();
                      if (requested == LocationPermission.denied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Location permission is required to show nearby events'),
                          ),
                        );
                        return;
                      }
                    }

                    if (permission == LocationPermission.deniedForever) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enable location permissions in app settings'),
                        ),
                      );
                      return;
                    }

                    // Get current position and fetch nearby events
                    final position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                    if (context.mounted) {
                      context.read<EventBloc>().add(
                            FetchNearbyEventsEvent(
                              latitude: position.latitude,
                              longitude: position.longitude,
                            ),
                          );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                        ),
                      );
                    }
                  }
                })
              else
                SizedBox(
                  height: cardHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.horizontalPadding * 0.5,
                    ),
                    itemCount: state.nearbyEvents.length,
                    controller: PageController(
                      viewportFraction:
                          0.85, // Shows part of next/previous items
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.horizontalPadding * 0.3,
                        ),
                        child: Stack(
                          children: [
                            LocationEventCard(
                              event: state.nearbyEvents[index],
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRouts.eventLogo,
                                arguments: state.nearbyEvents[index],
                              ),
                              isHorizontal: true,
                            ),
                            Positioned(
                              top: Responsive.verticalPadding * 0.4,
                              right: Responsive.horizontalPadding * 0.4,
                              child: Container(
                                padding: distanceChipPadding,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(
                                    Responsive.borderRadius * 0.6,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.directions_walk,
                                      size: distanceIconSize,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                        width: Responsive.spacingWidth * 0.2),
                                    GestureDetector(
                                      onTap: _userPosition == null
                                          ? _getCurrentLocation
                                          : null,
                                      child: Text(
                                        _userPosition == null
                                            ? 'Tap to retry'
                                            : _calculateDistance(
                                                state.nearbyEvents[index]
                                                    .latitude,
                                                state.nearbyEvents[index]
                                                    .longitude,
                                              ),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: distanceFontSize,
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
                    },
                  ),
                ),
          ],
        );
      },
    );
  }
}
