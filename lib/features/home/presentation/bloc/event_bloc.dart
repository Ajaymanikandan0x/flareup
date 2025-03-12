import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/utils/current_location.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/get_event_entite.dart';
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

  // Add cache variables
  List<GetAllEventEntities> _cachedEvents = [];
  List<CategoryEntity> _cachedCategories = [];

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
    on<SelectEventEvent>((event, emit) {
      if (state is EventsLoaded) {
        final currentState = state as EventsLoaded;
        emit(currentState.copyWith(
          selectedEvent: event.event,
        ));
      }
    });
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
    if (_cachedEvents.isNotEmpty) {
      emit(EventsLoaded(
        allEvents: _cachedEvents,
        trendingEvents: await getTrendingEventsUseCase(),
        nearbyEvents: const [],
        categories: await categoriesUseCase(),
        searchResults: const [],
        searchQuery: '',
      ));
      return;
    }
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
        
        Logger.debug('Emitting EventsLoaded state with: ${events.length} events, ${trending.length} trending events');
        _cachedEvents = events; // Cache after fetch
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
      Logger.debug('Filtering events for category ID: ${event.categoryId}, subcategory ID: ${event.subcategoryId}');
      
      // Find the category name from cached categories
      final category = _cachedCategories.firstWhere(
        (cat) => cat.id.toString() == event.categoryId,
        orElse: () => throw Exception('Category not found'),
      );

      // Find the subcategory/event type name if subcategoryId is provided
      String? eventTypeName;
      if (event.subcategoryId != null) {
        final eventType = category.eventTypes.firstWhere(
          (type) => type.id.toString() == event.subcategoryId,
          orElse: () => throw Exception('Event type not found'),
        );
        eventTypeName = eventType.name;
      }

      Logger.debug('Filtering by category: ${category.name}, event type: $eventTypeName');
      
      final filteredEvents = await getEventsByCategoryUseCase(
        category.name,
        subcategoryId: eventTypeName,
      );

      Logger.debug('Found ${filteredEvents.length} events after filtering');

      if (state is EventsLoaded) {
        final currentState = state as EventsLoaded;
        emit(currentState.copyWith(
          allEvents: filteredEvents,
          selectedCategoryId: event.categoryId,
          selectedSubCategoryId: event.subcategoryId,
        ));
      } else {
        emit(EventsLoaded(
          categories: const [],
          allEvents: filteredEvents,
          trendingEvents: const [],
          nearbyEvents: const [],
          searchResults: const [],
          selectedCategoryId: event.categoryId,
          selectedSubCategoryId: event.subcategoryId,
        ));
      }
    } catch (e) {
      Logger.error('Error filtering events:', e);
      emit(const EventError('Failed to load events for this category'));
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
      Logger.debug('=== Main Categories Details ===');
      
      for (var category in mainCategories) {
        Logger.debug('''
Main Category: ${category.name}
  ID: ${category.id}
  Description: ${category.description}
  Status: ${category.status}
  Updated At: ${category.updatedAt}
  Event Types Count: ${category.eventTypes.length}
  ''');

        // Log event types for this category
        if (category.eventTypes.isNotEmpty) {
          Logger.debug('  Event Types for ${category.name}:');
          for (var eventType in category.eventTypes) {
            Logger.debug('''
    - Event Type: ${eventType.name}
      ID: ${eventType.id}
      Description: ${eventType.description ?? 'No description'}
      Image: ${eventType.image ?? 'No image'}
      Updated At: ${eventType.updatedAt ?? 'No update date'}
  ''');
          }
        } else {
          Logger.debug('  No event types found for this category');
        }
        Logger.debug('--------------------------------');
      }

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
      Logger.debug('Fetching subcategories (event types) for parentId: ${event.parentCategoryId}');
      
      // Fetch all categories if we don't have them cached
      if (_cachedCategories.isEmpty) {
        _cachedCategories = await categoriesUseCase();
      }
      
      // Find the main category
      final mainCategory = _cachedCategories.firstWhere(
        (cat) => cat.id.toString() == event.parentCategoryId,
        orElse: () => throw Exception('Main category not found'),
      );
      
      Logger.debug('Found main category: ${mainCategory.name} with ${mainCategory.eventTypes.length} event types');
      
      // Convert event types to categories for display
      final subCategories = mainCategory.eventTypes.map((eventType) {
        return CategoryEntity(
          id: eventType.id,
          name: eventType.name,
          description: eventType.description ?? '',
          parentId: event.parentCategoryId,
          eventTypes: [],
          image: eventType.image ?? '',
          status: mainCategory.status,
          updatedAt: eventType.updatedAt != null 
            ? DateTime.tryParse(eventType.updatedAt.toString()) ?? DateTime.now()
            : DateTime.now(),
        );
      }).toList();
      
      Logger.debug('Successfully converted ${subCategories.length} event types to subcategories');
      for (var sub in subCategories) {
        Logger.debug('Subcategory: ${sub.name} (ID: ${sub.id}, parentId: ${sub.parentId})');
      }

      if (subCategories.isEmpty) {
        Logger.debug('No event types found for category: ${mainCategory.name}');
        emit(EventsLoaded(
          categories: [],
          allEvents: const [],
          trendingEvents: const [],
          nearbyEvents: const [],
          searchResults: const [],
          searchQuery: '',
          selectedSubCategoryId: event.parentCategoryId,
          isSubcategoryView: true,
        ));
        
        add(FilterEventsByCategoryEvent(event.parentCategoryId));
      } else {
        emit(EventsLoaded(
          categories: subCategories,
          allEvents: const [],
          trendingEvents: const [],
          nearbyEvents: const [],
          searchResults: const [],
          searchQuery: '',
          selectedSubCategoryId: event.parentCategoryId,
          isSubcategoryView: true,
        ));
      }
    } catch (e, stackTrace) {
      Logger.debug('Error fetching subcategories: $e\nStack trace: $stackTrace');
      emit(EventError('Unable to load subcategories. Please try again.'));
    }
  }
}
