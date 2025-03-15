import 'package:flareup/features/events/presentation/widgets/date_container.dart';
import 'package:flareup/features/events/presentation/widgets/expandable_text.dart';
import 'package:flareup/features/events/presentation/widgets/location_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/custom_video_widget.dart';
import '../../../../dependency_injector.dart';
import '../../../home/domain/entities/get_event_entite.dart';
import '../cubit/video_player_cubit.dart';
import '../widgets/booking_container.dart';
import '../widgets/loading/image_shimmer_loading.dart';
import '../widgets/text_container.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<EventHome> createState() => _EventHomeState();
}

class _EventHomeState extends State<EventHome> {
  late GetAllEventEntities event;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      event = ModalRoute.of(context)!.settings.arguments as GetAllEventEntities;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DependencyInjector().videoPlayerCubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Stack(
              children: [
                Stack(
                  children: [
                    CustomVideoWidget(
                      videoUrl: "$cloudinaryBaseUrl${event.promoVideo}",
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.4,
                      placeholder: ImageShimmerLoading(),
                      autoPlay: true,
                      looping: true,
                      videoPlayerCubit: context.read<VideoPlayerCubit>(),
                    ),
                  ],
                ),

                // Content
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Back and Action Buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back,
                                          color: Colors.white),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.white),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.share,
                                              color: Colors.white),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 200),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Event Type Label
                                          Text(
                                            event.type.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              letterSpacing: 1.2,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          const SizedBox(height: 8),

                                          // Event Title
                                          Hero(
                                            tag: 'event_title_${event.id}',
                                            child: Text(
                                              event.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),

                                          // Start Time
                                          Text(
                                            'STARTING ${DateFormat('h:mm a').format(event.startDateTime)}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Date Container
                                    DateContainer(
                                        date: event.startDateTime.toString())
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Tab Buttons
                                Row(
                                  children: [
                                    TextContainer(text: 'ABOUT'),
                                    const SizedBox(width: 16),
                                    TextContainer(text: 'PARTICIPANTS'),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Description
                                ExpandableText(text: event.description),

                                const SizedBox(height: 24),

                                // Location
                                LocationContainer(
                                  lat: event.latitude.toString(),
                                  lng: event.longitude.toString(),
                                ),

                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Add BookingPlace here, outside the ScrollView
                      BookingPlace(
                        onTap: () {},
                        price: event.ticketPrice.toString(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.18,
                  right: MediaQuery.of(context).size.width * 0.42,
                  child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
                    buildWhen: (previous, current) =>
                        previous.isPlaying != current.isPlaying,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          try {
                            context.read<VideoPlayerCubit>().togglePlayPause();
                          } catch (e) {
                            debugPrint("Error toggling play/pause: $e");
                          }
                        },
                        child: TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 200),
                          tween: Tween<double>(
                            begin: state.isPlaying ? 0.8 : 1.0,
                            end: state.isPlaying ? 1.0 : 0.8,
                          ),
                          builder: (context, double scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(40),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withAlpha(40),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(20),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    state.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    key: ValueKey(state.isPlaying),
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
