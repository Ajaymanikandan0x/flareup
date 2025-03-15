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

      // Filter events that are approved and active
      final events = response.data!
          .where((model) =>
              model.bannerImage.isNotEmpty &&
              model.approvalStatus.toLowerCase() == 'approved' &&
              model.status.toLowerCase() == 'active')
          .map((model) => model.toEntity())
          .toList();

      Logger.debug('Returning ${events.length} approved and active events');
      return events;
    } catch (e) {
      Logger.error('Get all events error:', e);
      rethrow;
    }
  }

  @override
  Future<List<GetAllEventEntities>> getEventsByCategory(String categoryName,
      {String? subcategoryId}) async {
    try {
      final response = await _remoteDataSource.getAllEvents();

      if (response.data == null) {
        return [];
      }

      final events = response.data!
          .where((model) {
            // Check approval status first
            if (model.approvalStatus.toLowerCase() != 'active' ||
                model.bannerImage.isEmpty) {
              return false;
            }

            final categoryMatch = model.category.trim().toLowerCase() ==
                categoryName.trim().toLowerCase();

            if (subcategoryId != null && model.type != null) {
              final typeMatch = model.type.trim().toLowerCase() ==
                  subcategoryId.trim().toLowerCase();
              return categoryMatch && typeMatch;
            }

            return categoryMatch;
          })
          .map((model) => model.toEntity())
          .toList();

      Logger.debug(
          'Filtered ${events.length} approved events for category: $categoryName');
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
          .where((model) =>
              model.bannerImage.isNotEmpty &&
              model.approvalStatus.toLowerCase() == 'approved' &&
              model.status.toLowerCase() == 'active')
          .map((model) => model.toEntity())
          .toList();

      Logger.debug('Returning ${events.length} approved nearby events');
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
          .where((model) =>
              model.bannerImage.isNotEmpty &&
              model.approvalStatus.toLowerCase() == 'approved' &&
              model.status.toLowerCase() == 'active')
          .map((model) => model.toEntity())
          .toList();

      Logger.debug('Returning ${events.length} approved trending events');
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
          .where((model) =>
              model.bannerImage.isNotEmpty &&
              model.approvalStatus.toLowerCase() == 'approved' &&
              model.status.toLowerCase() == 'active')
          .map((model) => model.toEntity())
          .toList();

      Logger.debug(
          'Returning ${events.length} approved events matching query: $query');
      return events;
    } catch (e) {
      Logger.error('Search events error:', e);
      rethrow;
    }
  }
}
