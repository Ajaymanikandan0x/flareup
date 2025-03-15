import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/home/presentation/bloc/event_bloc.dart';
import '../../features/home/presentation/bloc/event_event.dart';
import '../../features/home/presentation/screens/search_result.dart';
import '../../features/home/presentation/widgets/ SearchOverlay .dart';
import '../routes/routs.dart';

class EventSearchBar extends StatefulWidget {
  const EventSearchBar({super.key});

  @override
  State<EventSearchBar> createState() => _EventSearchBarState();
}

class _EventSearchBarState extends State<EventSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _removeSearchOverlay();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      if (_overlayEntry == null) {
        _showSearchOverlay();
        context.read<EventBloc>().add(const ShowAllEventsEvent());
      }
    } else {
      _removeSearchOverlay();
      _searchController.clear();
    }
  }

  void _showSearchOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => SearchOverlay(
        searchController: _searchController,
        focusNode: _focusNode,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeSearchOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1C2029)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouts.searchResults,
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
                  size: 24,
                ),
              ),
              Expanded(
                child: Text(
                  'Search event..',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
