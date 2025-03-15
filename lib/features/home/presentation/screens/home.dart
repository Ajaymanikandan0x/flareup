import 'package:flareup/features/home/presentation/widgets/drawer.dart';
import 'package:flareup/features/home/presentation/widgets/sections/all_events_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../widgets/cards/search_events.dart';
import '../widgets/sections/nearby_section.dart';
import '../widgets/sections/trending_section.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  void initState() {
    super.initState();
    // Load data only once when widget initializes
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initialLoad();
    });
  }

  Future<void> _initialLoad() async {
    if (!mounted) return;

    try {
      // Load all data in parallel
      await Future.wait<void>([
        _loadEvents(),
      ]);
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to load initial data');
    }
  }

  Future<void> _loadEvents() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventBlocState>(
        builder: (context, state) {
          if (state is EventInitial) {
            return const CircularProgressIndicator();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await _initialLoad();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SearchEvents(),
                  TrendingSection(),
                  NearbySection(),
                  AllEventsSection(),
                ],
              ),
            ),
          );
        },
      ),
      drawer: AppDrawer(),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
