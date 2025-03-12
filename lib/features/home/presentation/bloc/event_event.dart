import 'package:equatable/equatable.dart';

import '../../domain/entities/get_event_entite.dart';

abstract class EventBlocEvent extends Equatable {
  const EventBlocEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllEventsEvent extends EventBlocEvent {
  const FetchAllEventsEvent();
}

class FetchTrendingEventsEvent extends EventBlocEvent {
  const FetchTrendingEventsEvent();
}

class FetchNearbyEventsEvent extends EventBlocEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const FetchNearbyEventsEvent({
    required this.latitude,
    required this.longitude,
    this.radius = 10.0, // Default 10km radius
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

class SearchEventsEvent extends EventBlocEvent {
  final String query;

  const SearchEventsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterEventsByCategoryEvent extends EventBlocEvent {
  final String categoryId;
  final String? subcategoryId;

  const FilterEventsByCategoryEvent(this.categoryId, {this.subcategoryId});

  @override
  List<Object?> get props => [categoryId, subcategoryId];
}

class FetchCategoriesEvent extends EventBlocEvent {
  const FetchCategoriesEvent();
}

class FetchSubCategoriesEvent extends EventBlocEvent {
  final String parentCategoryId;

  const FetchSubCategoriesEvent(this.parentCategoryId);

  @override
  List<Object?> get props => [parentCategoryId];
}

class SelectEventEvent extends EventBlocEvent {
  final GetAllEventEntities event;

  const SelectEventEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class ShowAllEventsEvent extends EventBlocEvent {
  const ShowAllEventsEvent();
}
