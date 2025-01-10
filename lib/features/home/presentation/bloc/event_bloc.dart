import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/utils/current_location.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/GetNearbyEventsUseCase.dart';
import '../../domain/usecases/GetTrendingEventsUseCase .dart';
import '../../domain/usecases/get_event_usecase.dart';

import '../../domain/usecases/category_usecase.dart';

import '../../domain/usecases/get_eventby_category_usecase.dart';
import 'event_event.dart';
import 'event_state.dart';
import '../../../../core/utils/debouncer.dart';
import 'package:geolocator/geolocator.dart';


class EventBloc extends Bloc<EventBlocEvent, EventBlocState> {

  final GetAllEventsUseCase getAllEventsUseCase;
  final GetTrendingEventsUseCase getTrendingEventsUseCase;
  final GetNearbyEventsUseCase getNearbyEventsUseCase;
  final GetEventsByCategoryUseCase getEventsByCategoryUseCase;
  final CategoriesUseCase categoriesUseCase;
  final Debouncer _searchDebouncer = Debouncer();

  EventBloc({
    required this.getAllEventsUseCase,
    required this.getTrendingEventsUseCase,
    required this.getNearbyEventsUseCase,
    required this.getEventsByCategoryUseCase,
    required this.categoriesUseCase,
  })  : super(EventInitial()) {
    on<FetchAllEventsEvent>(_onFetchAllEvents);
    on<FetchTrendingEventsEvent>(_onFetchTrendingEvents);
    on<FetchNearbyEventsEvent>(_onFetchNearbyEvents);
    on<SearchEventsEvent>(_onSearchEvents);
    on<FilterEventsByCategoryEvent>(_onFilterEventsByCategory);
    on<ShowAllEventsEvent>(_onShowAllEvents);
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<FetchSubCategoriesEvent>(_onFetchSubCategories);
  }

  @override
  Future<void> close() {
    _searchDebouncer.dispose();
    return super.close();
  }

  Future<void> _onFetchAllEvents(
    FetchAllEventsEvent event,
    Emitter<EventBlocState> emit,
  ) async {
    try {
      emit(EventLoading());
      Logger.debug('Fetching all events...');
      
      final events = await getAllEventsUseCase();
      Logger.debug('Fetched ${events.length} events');
      
      final trending = await getTrendingEventsUseCase();
      Logger.debug('Fetched ${trending.length} trending events');
      
      try {
        final categories = await categoriesUseCase();
        Logger.debug('Fetched ${categories.length} categories');
        
        emit(EventsLoaded(
          allEvents: events,
          trendingEvents: trending,
          nearbyEvents: const [],
          categories: categories,
          searchResults: const [],
          searchQuery: '',
        ));
      } catch (categoryError) {
        // Still show events even if categories fail to load
        Logger.error('Error fetching categories:', categoryError);
        emit(EventsLoaded(
          allEvents: events,
          trendingEvents: trending,
          nearbyEvents: const [],
          categories: const [],
          searchResults: const [],
          searchQuery: '',
        ));
      }
    } catch (e) {
      Logger.error('Error fetching events:', e);
      String message = 'Unable to load events';
      if (e is AppError) {
        if (e.type == ErrorType.network) {
          message = 'Please check your internet connection';
        } else if (e.type == ErrorType.server) {
          message = 'Service temporarily unavailable';
        }
      }
      emit(EventError(message));
    }
  }

  Future<void> _onFetchTrendingEvents(
    FetchTrendingEventsEvent event,
    Emitter<EventBlocState> emit,
  ) async {
    // Implementation for fetching trending events
  }

  Future<void> _onFetchNearbyEvents(
    FetchNearbyEventsEvent event,
    Emitter<EventBlocState> emit,
  ) async {
    try {
      if (state is! EventsLoaded) {
        emit(EventLoading());
      }

      // Check if location permission is granted
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied) {
          emit(EventError('Location permission denied'));
          return;
        }
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final nearbyEvents = await getNearbyEventsUseCase(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: event.radius,
      );

      if (state is EventsLoaded) {
        final currentState = state as EventsLoaded;
        emit(currentState.copyWith(nearbyEvents: nearbyEvents));
      } else {
        emit(EventsLoaded(
          allEvents: const [],
          trendingEvents: const [],
          nearbyEvents: nearbyEvents,
          categories: const [],
          searchResults: const [],
          searchQuery: '',
        ));
      }
    } catch (e) {
      Logger.error('Fetch nearby events error:', e);
      emit(EventError(e.toString()));
    }
  }

  Future<void> _onSearchEvents(
    SearchEventsEvent event,
    Emitter<EventBlocState> emit,
  ) async {
    Logger.debug('Search initiated with query: "${event.query}"');
    
    if (state is! EventsLoaded) {
      Logger.debug('Search canceled - State is not EventsLoaded');
      return;
    }
    
    final currentState = state as EventsLoaded;
    Logger.debug('Current all events count: ${currentState.allEvents.length}');
    
    try {
      // If query is empty, clear search results
      if (event.query.isEmpty) {
        Logger.debug('Empty query - clearing search results');
        emit(currentState.copyWith(
          searchQuery: '',
          searchResults: const [],
          isSearching: false,
        ));
        return;
      }

      // Add loading state for search
      Logger.debug('Setting search loading state');
      emit(currentState.copyWith(
        searchQuery: event.query,
        isSearching: true,
      ));

      final query = event.query.toLowerCase();
      Logger.debug('Filtering events with query: "$query"');
      
      final filteredEvents = currentState.allEvents.where((event) {
        final matches = event.title.toLowerCase().contains(query) ||
               event.description.toLowerCase().contains(query) ||
               event.category.toLowerCase().contains(query) ||
               event.type.toLowerCase().contains(query) ||
               event.city.toLowerCase().contains(query);
               
        if (matches) {
          Logger.debug('Match found: ${event.title}');
        }
        return matches;
      }).toList();

      Logger.debug('Found ${filteredEvents.length} matching events');

      emit(currentState.copyWith(
        searchQuery: query,
        searchResults: filteredEvents,
        isSearching: false,
        searchError: null,
      ));
    } catch (e) {
      Logger.error('Search error:', e);
      emit(currentState.copyWith(
        searchError: 'Search failed: ${e.toString()}',
        isSearching: false,
      ));
    }
  }

  Future<void> _onFilterEventsByCategory(
    FilterEventsByCategoryEvent event,
    Emitter<EventBlocState> emit,
  ) async {
    try {
      emit(EventLoading());
      Logger.debug('Filtering events for category: ${event.category}');
      
      final filteredEvents = await getEventsByCategoryUseCase(event.category);
      
      if (state is EventsLoaded) {
        final currentState = state as EventsLoaded;
        emit(currentState.copyWith(
          allEvents: filteredEvents,
          selectedCategoryId: event.category,
          selectedSubCategoryId: event.category,
        ));
      } else {
        emit(EventsLoaded(
          allEvents: filteredEvents,
          trendingEvents: const [],
          nearbyEvents: const [],
          categories: const [],
          searchResults: const [],
          searchQuery: '',
          selectedCategoryId: event.category,
          selectedSubCategoryId: event.category,
        ));
      }
    } catch (e) {
      Logger.error('Error filtering events:', e);
      emit(EventError('Failed to load events for this category'));
    }
  }

  Future<void> refreshNearbyEvents() async {
    try {
      final position = await getCurrentPosition();
      add(FetchNearbyEventsEvent(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      // Handle location error
      emit(EventError('Failed to get location: ${e.toString()}'));
    }
  }

  Future<void> _onShowAllEvents(
    ShowAllEventsEvent event,
    Emitter<EventBlocState> emit,
  ) async {
    try {
      if (state is! EventsLoaded) {
        // If state is not loaded, fetch all events first
        await _onFetchAllEvents(const FetchAllEventsEvent(), emit);
        return;
      }
      
      final currentState = state as EventsLoaded;
      Logger.debug('Showing all ${currentState.allEvents.length} events in search');
      
      // Keep the current state but update search results
      emit(currentState.copyWith(
        searchResults: currentState.allEvents,
        searchQuery: '',
        isSearching: false,
        searchError: null,
      ));
    } catch (e) {
      Logger.error('Show all events error:', e);
      if (state is EventsLoaded) {
        final currentState = state as EventsLoaded;
        emit(currentState.copyWith(
          searchError: 'Failed to show events: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onFetchCategories(
    FetchCategoriesEvent event,
    Emitter<EventBlocState> emit,
  ) async {
    try {
      emit(EventLoading());
      Logger.debug('Fetching main categories...');
      
      final categories = await categoriesUseCase();
      final mainCategories = categories.where((cat) => cat.parentId == null).toList();
      
      Logger.debug('Fetched ${mainCategories.length} main categories');
      
      if (mainCategories.isEmpty) {
        emit(EventsLoaded(
          categories: [],
          allEvents: const [],
          trendingEvents: const [],
          nearbyEvents: const [],
          searchResults: const [],
          searchQuery: '',
          searchError: 'No categories available at the moment. Please try again later.',
        ));
        return;
      }
      
      emit(EventsLoaded(
        categories: mainCategories,
        allEvents: const [],
        trendingEvents: const [],
        nearbyEvents: const [],
        searchResults: const [],
        searchQuery: '',
      ));
    } catch (e) {
      Logger.error('Error fetching categories:', e);
      String message = 'Unable to load categories';
      if (e is AppError) {
        if (e.type == ErrorType.network) {
          message = 'Please check your internet connection';
        } else if (e.type == ErrorType.server) {
          message = 'Categories are temporarily unavailable. Please try again later.';
        }
      }
      emit(EventError(message));
    }
  }

  Future<void> _onFetchSubCategories(
    FetchSubCategoriesEvent event,
    Emitter<EventBlocState> emit,
  ) async {
    try {
      emit(EventLoading());
      Logger.debug('Fetching subcategories for ${event.parentCategoryId}...');
      
      final categories = await categoriesUseCase();
      // Filter subcategories for the selected parent
      final subCategories = categories
          .where((cat) => cat.parentId == event.parentCategoryId)
          .toList();
      
      Logger.debug('Fetched ${subCategories.length} subcategories');
      
      emit(EventsLoaded(
        categories: subCategories,
        allEvents: const [],
        trendingEvents: const [],
        nearbyEvents: const [],
        searchResults: const [],
        searchQuery: '',
      ));
    } catch (e) {
      Logger.error('Error fetching subcategories:', e);
      emit(EventError('Unable to load subcategories'));
    }
  }
}
