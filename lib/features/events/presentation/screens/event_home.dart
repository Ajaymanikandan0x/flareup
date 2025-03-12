import 'package:flareup/features/events/presentation/screens/dummy_event_home.dart';
import 'package:flareup/features/events/presentation/widgets/date_container.dart';
import 'package:flareup/features/events/presentation/widgets/expandable_text.dart';
import 'package:flareup/features/events/presentation/widgets/location_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/custom_image_wid.dart';
import '../widgets/booking_container.dart';
import '../widgets/loading/image_shimmer_loading.dart';
import '../widgets/text_container.dart';

class EventHome extends StatelessWidget {
  const EventHome({super.key});

  @override
  Widget build(BuildContext context) {
    final event = DummyEventHome.sampleEvent;
    return Scaffold(
      body: Stack(
        children: [
          // Banner Image with Gradient Overlay
          Positioned.fill(
            child: Stack(
              children: [
                CustomImageWidget(
                  imageUrl: event.bannerImage,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  placeholder: ImageShimmerLoading(),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.black,
                      ],
                      stops: const [0.0, 0.4, 0.75, 1.0],
                    ),
                  ),
                ),
              ],
            ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Event Type Label
                                    Text(
                                      'SHOW',
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
                                      tag: event.title,
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
        ],
      ),
    );
  }
}
