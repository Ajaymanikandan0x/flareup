import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/routs.dart';
import '../../../domain/entities/get_event_entite.dart';
import '../../bloc/event_bloc.dart';
import '../../bloc/event_event.dart';
import '../../bloc/event_state.dart';
import '../../widgets/cards/eventcard.dart';
import '../../widgets/shimmer/event_card_shimmer.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh events for current category
          final categoryId =
              context.read<EventBloc>().state.selectedSubCategoryId;
          if (categoryId != null) {
            context
                .read<EventBloc>()
                .add(FilterEventsByCategoryEvent(categoryId));
          }
        },
        child: BlocBuilder<EventBloc, EventBlocState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return _buildLoadingShimmer();
            }

            if (state is EventError) {
              return _buildErrorState(context, state.message);
            }

            if (state is EventsLoaded) {
              if (state.allEvents.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                itemCount: state.allEvents.length,
                itemBuilder: (context, index) {
                  final event = state.allEvents[index];
                  return EventCard(
                    event: event,
                    onTap: () => _navigateToEventDetails(context, event),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const EventCardShimmer(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No events found for this category',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final categoryId =
                  context.read<EventBloc>().state.selectedSubCategoryId;
              if (categoryId != null) {
                context
                    .read<EventBloc>()
                    .add(FilterEventsByCategoryEvent(categoryId));
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _navigateToEventDetails(
      BuildContext context, GetAllEventEntities event) {
    context.read<EventBloc>().add(SelectEventEvent(event));
    Navigator.pushNamed(context, AppRouts.eventLogo);
  }
}
