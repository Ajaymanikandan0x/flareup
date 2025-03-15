import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/routs.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../bloc/event_bloc.dart';
import '../../bloc/event_event.dart';
import '../../bloc/event_state.dart';
import '../cards/all_event_card.dart';

class AllEventsSection extends StatelessWidget {
  const AllEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventBlocState>(
      builder: (context, state) {
        if (state is EventsLoaded) {
          if (state.allEvents.isEmpty) {
            return const Center(child: Text('No events available'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.horizontalPadding,
                  vertical: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Events',
                      style: AppTextStyles.primaryTextTheme().copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRouts.eventList,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.horizontalPadding,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: Responsive.spacingWidth * 0.1,
                  mainAxisSpacing: Responsive.spacingHeight * 0.5,
                ),
                itemCount:
                    state.allEvents.length > 4 ? 4 : state.allEvents.length,
                itemBuilder: (context, index) {
                  final event = state.allEvents[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return AllEventCard(
                        event: event,
                        onTap: () {
                          context
                              .read<EventBloc>()
                              .add(SelectEventEvent(event));
                          Navigator.pushNamed(
                            context,
                            AppRouts.eventLogo,
                            arguments: event,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          );
        }

        if (state is EventLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return const SizedBox.shrink();
      },
    );
  }
}
