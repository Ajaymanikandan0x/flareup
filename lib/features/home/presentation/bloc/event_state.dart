import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/get_event_entite.dart';

abstract class EventBlocState extends Equatable {
  final String? selectedSubCategoryId;

  const EventBlocState({this.selectedSubCategoryId});

  @override
  List<Object?> get props => [selectedSubCategoryId];
}

class EventInitial extends EventBlocState {}

class EventLoading extends EventBlocState {}

class EventError extends EventBlocState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}

class EventsLoaded extends EventBlocState {
  final List<GetAllEventEntities> allEvents;
  final List<GetAllEventEntities> trendingEvents;
  final List<GetAllEventEntities> nearbyEvents;
  final List<GetAllEventEntities> searchResults;
  final List<CategoryEntity> categories;
  final String searchQuery;
  final bool isSearching;
  final String? searchError;
  final GetAllEventEntities? selectedEvent;
  final String? selectedCategoryId;
  final bool isSubcategoryView;

  const EventsLoaded({
    required this.allEvents,
    required this.trendingEvents,
    required this.nearbyEvents,
    required this.categories,
    required this.searchResults,
    this.searchQuery = '',
    this.isSearching = false,
    this.searchError,
    this.selectedEvent,
    this.selectedCategoryId,
    this.isSubcategoryView = false,
    String? selectedSubCategoryId,
  }) : super(selectedSubCategoryId: selectedSubCategoryId);

  @override
  List<Object?> get props => [
        allEvents,
        trendingEvents,
        nearbyEvents,
        categories,
        searchResults,
        searchQuery,
        isSearching,
        searchError,
        selectedEvent,
        selectedCategoryId,
        isSubcategoryView,
      ];

  EventsLoaded copyWith({
    List<GetAllEventEntities>? allEvents,
    List<GetAllEventEntities>? trendingEvents,
    List<GetAllEventEntities>? nearbyEvents,
    List<CategoryEntity>? categories,
    List<GetAllEventEntities>? searchResults,
    String? searchQuery,
    bool? isSearching,
    String? searchError,
    GetAllEventEntities? selectedEvent,
    String? selectedCategoryId,
    bool? isSubcategoryView,
    String? selectedSubCategoryId,
  }) {
    return EventsLoaded(
      allEvents: allEvents ?? this.allEvents,
      trendingEvents: trendingEvents ?? this.trendingEvents,
      nearbyEvents: nearbyEvents ?? this.nearbyEvents,
      categories: categories ?? this.categories,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      searchError: searchError ?? this.searchError,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isSubcategoryView: isSubcategoryView ?? this.isSubcategoryView,
      selectedSubCategoryId:
          selectedSubCategoryId ?? this.selectedSubCategoryId,
    );
  }
}
