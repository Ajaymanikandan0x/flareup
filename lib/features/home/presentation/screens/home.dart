import 'package:flareup/core/routes/routs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/search_bar.dart';
import '../../domain/entities/get_event_entite.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../widgets/category_widget/category_chip.dart';
import '../widgets/drawer.dart';
import '../widgets/empty_state.dart';
import '../widgets/eventcard.dart';
import '../widgets/shimmer/category_shimmer.dart';
import '../widgets/shimmer/event_card_shimmer.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadEvents();
    _loadCategories();
  }

  void _loadEvents() async {
    try {
      context.read<EventBloc>().add(const FetchAllEventsEvent());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load events'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _loadCategories() {
    try {
      context.read<EventBloc>().add(const FetchCategoriesEvent());
    } catch (e) {
      // Use addPostFrameCallback to show SnackBar after build
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load categories'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void _loadNearbyEvents() async {
    try {
      // Check location services
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Location Services Disabled'),
              content: const Text(
                  'Please enable location services to see nearby events.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        context.read<EventBloc>().add(FetchNearbyEventsEvent(
              latitude: position.latitude,
              longitude: position.longitude,
              radius: 10.0, // 10km radius
            ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return BlocListener<EventBloc, EventBlocState>(
      listener: (context, state) {
        if (state is EventError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.bell),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () async => _loadEvents(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(child: EventSearchBar()),
                    _category(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(Responsive.horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories
                      BlocBuilder<EventBloc, EventBlocState>(
                        builder: (context, state) {
                          if (state is EventLoading) {
                            return const CategoryShimmer();
                          }

                          if (state is EventsLoaded &&
                              state.categories.isNotEmpty) {
                            return Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(
                                  horizontal: Responsive.horizontalPadding),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.categories.length,
                                itemBuilder: (context, index) {
                                  return CategoryChip(
                                    category: state.categories[index].name,
                                  );
                                },
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),

                      SizedBox(height: Responsive.spacingHeight),

                      // Trending Events
                      _buildSectionHeader('Trending Events'),
                      BlocBuilder<EventBloc, EventBlocState>(
                        builder: (context, state) {
                          if (state is EventLoading) {
                            return SizedBox(
                              height: 400,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) =>
                                    const EventCardShimmer(isHorizontal: true),
                              ),
                            );
                          }

                          if (state is EventsLoaded) {
                            if (state.trendingEvents.isEmpty) {
                              return const EmptyStateCategory(
                                message: 'No trending events available',
                                icon: Icons.trending_up,
                              );
                            }
                            return _buildTrendingEvents(state.trendingEvents);
                          }

                          return const SizedBox.shrink();
                        },
                      ),

                      SizedBox(height: Responsive.spacingHeight * 2),

                      // Events Near You
                      _buildSectionHeader('Events Near You'),
                      BlocBuilder<EventBloc, EventBlocState>(
                        builder: (context, state) {
                          if (state is EventLoading) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (context, index) =>
                                  const EventCardShimmer(),
                            );
                          }

                          if (state is EventsLoaded) {
                            if (state.nearbyEvents.isEmpty) {
                              return const EmptyStateCategory(
                                message: 'No events found nearby',
                                icon: Icons.location_off,
                              );
                            }
                            return _buildNearbyEvents(state.nearbyEvents);
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Responsive.titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRouts.category);
          },
          child: const Text('See all'),
        ),
      ],
    );
  }

  Widget _buildTrendingEvents(List<GetAllEventEntities> events) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 300,
            child: EventCard(
              event: events[index],
              isHorizontal: true,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyEvents(List<GetAllEventEntities> events) {
    return SizedBox(
      height: events.length * 300.0, // Approximate height per card
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            event: events[index],
            isHorizontal: false,
          );
        },
      ),
    );
  }

  Widget _category() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(
          Icons.tune,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
          size: 24,
        ),
      ),
    );
  }
}
