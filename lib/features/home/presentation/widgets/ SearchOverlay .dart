
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/logger.dart';

import '../bloc/event_bloc.dart';
import '../bloc/event_state.dart';
import '../screens/search_result.dart';

class SearchOverlay extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;

  const SearchOverlay({
    super.key,
    required this.searchController,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    Logger.debug('Building SearchOverlay');
    return SafeArea(
      child: Column(
        children: [
          // _buildSearchHeader(context),
          BlocBuilder<EventBloc, EventBlocState>(
            builder: (context, state) {
              Logger.debug('SearchOverlay state: $state');
              if (state is! EventsLoaded) {
                Logger.debug('State is not EventsLoaded');
                return const Expanded(
                  child: Center(child: Text('Loading...')),
                );
              }

              if (state.isSearching) {
                Logger.debug('Showing search loading indicator');
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.searchError != null) {
                Logger.debug('Showing search error: ${state.searchError}');
                return Expanded(
                  child: Center(child: Text(state.searchError!)),
                );
              }

              Logger.debug(
                  'Showing search results: ${state.searchResults.length} items');
              return Expanded(child: SearchResults());
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildSearchHeader(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).scaffoldBackgroundColor,
  //       border: Border(
  //         bottom: BorderSide(
  //           color: Theme.of(context).dividerColor.withOpacity(0.1),
  //         ),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           icon: Icon(
  //             Icons.arrow_back,
  //             color: Theme.of(context).iconTheme.color,
  //           ),
  //           onPressed: () => focusNode.unfocus(),
  //         ),
  //         Expanded(
  //           child: Container(
  //             height: 40,
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               borderRadius: BorderRadius.circular(20),
  //               border: Border.all(
  //                 color: Theme.of(context).dividerColor.withOpacity(0.1),
  //               ),
  //             ),
  //             child: TextField(
  //               controller: searchController,
  //               focusNode: focusNode,
  //               autofocus: true,
  //               onChanged: (query) {
  //                 context.read<EventBloc>().add(SearchEventsEvent(query));
  //               },
  //               decoration: InputDecoration(
  //                 hintText: 'Search events..',
  //                 hintStyle: TextStyle(
  //                   color: Theme.of(context).hintColor,
  //                 ),
  //                 prefixIcon: Icon(
  //                   Icons.search,
  //                   color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
  //                 ),
  //                 border: InputBorder.none,
  //                 contentPadding: const EdgeInsets.symmetric(
  //                   horizontal: 16,
  //                   vertical: 8,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
