import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/custom_image_wid.dart';
import '../../domain/entities/get_event_entite.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../widgets/empty_states/empty_state.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2029),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.search,
                        color: AppPalette.white,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        style: AppTextStyles.primaryTextTheme(),
                        onChanged: (query) {
                          context
                              .read<EventBloc>()
                              .add(SearchEventsEvent(query));
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          hintText: 'Search event..',
                          hintStyle: TextStyle(
                            color: AppPalette.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Results List
            Expanded(
              child: BlocBuilder<EventBloc, EventBlocState>(
                builder: (context, state) {
                  if (state is! EventsLoaded) {
                    context.read<EventBloc>().add(const FetchAllEventsEvent());
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.isSearching) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final eventsToShow = (state.searchResults.isEmpty &&
                          (state.searchQuery.isEmpty ||
                              state.searchQuery == ''))
                      ? state.allEvents
                      : state.searchResults;

                  if (eventsToShow.isEmpty) {
                    if (state.searchQuery.isNotEmpty) {
                      return EmptyStateCategory(
                        message:
                            'No results found for "${state.searchQuery}"\nTry a different search term',
                        icon: Icons.search_off,
                      );
                    }

                    // Show different message for general empty state
                    return EmptyStateCategory(
                      message:
                          'No events available at the moment\nCheck back later for updates',
                      icon: Icons.event_busy,
                      onRetry: () => context
                          .read<EventBloc>()
                          .add(const FetchAllEventsEvent()),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: eventsToShow.length,
                    itemBuilder: (context, index) {
                      return _buildSearchResultItem(
                          context, eventsToShow[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(
      BuildContext context, GetAllEventEntities event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToEventDetails(context, event),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: "$cloudinaryBaseUrl${event.bannerImage}.png",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_formatDate(event.startDateTime)} - ${_formatTime(event.startDateTime)}',
                        style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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

  void _navigateToEventDetails(
      BuildContext context, GetAllEventEntities event) {
    Navigator.pushNamed(
      context,
      AppRouts.eventLogo,
      arguments: event,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${date.minute.toString().padLeft(2, '0')} $period';
  }
}
