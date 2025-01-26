import 'package:dio/dio.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/get_event_entite.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';

class EventRepositoryImpl implements EventRepositoryDomain {
  final EventRemoteDataSource _remoteDataSource;

  EventRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await _remoteDataSource.getEventCategories();
      if (!response.success) {
        Logger.debug(
            'Categories fetch was not successful, returning empty list');
        return [];
      }
      return response.data?.map((model) => model.toEntity()).toList() ?? [];
    } catch (e) {
      Logger.error('Repository error getting categories:', e);
      if (e is DioException && e.response?.statusCode == 500) {
        // Return empty list for server errors instead of throwing
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<List<GetAllEventEntities>> getAllEvents() async {
    try {
      final response = await _remoteDataSource.getAllEvents();

      if (response.data == null) {
        return [];
      }

      // Modified validation to accept any non-empty banner image
      final events = response.data!
          .where((model) => model.bannerImage.isNotEmpty)
          .map((model) => model.toEntity())
          .toList();

      Logger.debug('Returning ${events.length} valid events');
      return events;
    } catch (e) {
      Logger.error('Get all events error:', e);
      rethrow;
    }
  }

  @override
  Future<List<GetAllEventEntities>> getEventsByCategory(String category) async {
    try {
      final response = await _remoteDataSource.getEventsByCategory(category);

      if (response.data == null) {
        return [];
      }

      final events = response.data!
          .where((model) => model.bannerImage.isNotEmpty)
          .map((model) => model.toEntity())
          .toList();

      Logger.debug('Returning ${events.length} events for category: $category');
      return events;
    } catch (e) {
      Logger.error('Get events by category error:', e);
      rethrow;
    }
  }

  @override
  Future<List<GetAllEventEntities>> getNearbyEvents(
      {required double latitude,
      required double longitude,
      double radius = 5.0 // Default radius in kilometers
      }) async {
    try {
      final response = await _remoteDataSource.getNearbyEvents(
          latitude: latitude, longitude: longitude, radius: radius);

      if (response.data == null) {
        return [];
      }

      final events = response.data!
          .where((model) => model.bannerImage.isNotEmpty)
          .map((model) => model.toEntity())
          .toList();

      Logger.debug(
          'Returning ${events.length} nearby events within ${radius}km');
      return events;
    } catch (e) {
      Logger.error('Get nearby events error:', e);
      rethrow;
    }
  }

  @override
  Future<List<GetAllEventEntities>> getTrendingEvents() async {
    try {
      final response = await _remoteDataSource.getTrendingEvents();

      if (response.data == null) {
        return [];
      }

      final events = response.data!
          .where((model) => model.bannerImage.isNotEmpty)
          .map((model) => model.toEntity())
          .toList();

      Logger.debug('Returning ${events.length} trending events');
      return events;
    } catch (e) {
      Logger.error('Get trending events error:', e);
      rethrow;
    }
  }

  @override
  Future<List<GetAllEventEntities>> searchEvents(String query) async {
    try {
      final response = await _remoteDataSource.searchEvents(query);

      if (response.data == null) {
        return [];
      }

      final events = response.data!
          .where((model) => model.bannerImage.isNotEmpty)
          .map((model) => model.toEntity())
          .toList();

      Logger.debug('Returning ${events.length} events matching query: $query');
      return events;
    } catch (e) {
      Logger.error('Search events error:', e);
      rethrow;
    }
  }
}
