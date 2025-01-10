import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/base_api_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/all_event_model.dart';
import '../models/category_model.dart';
import 'event_remote_datasource.dart';

class EventRemoteDataSourceImpl extends BaseApiClient
    implements EventRemoteDataSource {
  EventRemoteDataSourceImpl(
    super.networkService,
    super.storageService,
  );

  @override
  Future<ApiResponse<List<GetAllEventModel>>> getAllEvents() async {
    try {
      final endpoint =
          '${ApiEndpoints.eventBaseUrl}${ApiEndpoints.getAllEvents}';
      Logger.debug('Fetching events from endpoint: $endpoint');

      final options = await getRequestOptions();
      final response = await networkService.dio
          .get(
            endpoint,
            options: options,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw AppError(
          userMessage: 'Failed to fetch events',
          technicalMessage:
              'Status: ${response.statusCode}, Data: ${response.data}',
          type: ErrorType.server,
        );
      }

      Logger.debug('Raw response data: ${response.data}');

      if (response.data == null) {
        return ApiResponse.success(
          message: 'No events found',
          data: [],
        );
      }

      final eventsList = response.data as List;
      Logger.debug('Events list length: ${eventsList.length}');

      final mappedEvents = eventsList.map((json) {
        Logger.debug('Processing event JSON: $json');
        try {
          return GetAllEventModel.fromJson(json);
        } catch (e) {
          Logger.error('Error parsing event: $json', e);
          rethrow;
        }
      }).toList();

      return ApiResponse.success(
        message: 'Events fetched successfully',
        data: mappedEvents,
      );
    } catch (e) {
      Logger.error('Get events error:', e);
      if (e is DioException) {
        throw AppError(
          userMessage: 'Network error while fetching events',
          technicalMessage: e.toString(),
          type: ErrorType.network,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ApiResponse<List<CategoryModel>>> getEventCategories() async {
    try {
      final endpoint =
          '${ApiEndpoints.eventBaseUrl}${ApiEndpoints.eventCategory}';

      final response = await networkService.dio.get(
        endpoint,
        options: await getRequestOptions(),
      );

      if (response.statusCode == 500) {
        Logger.error(
            'Server error when fetching categories. Returning empty list.',
            response.data);
        return ApiResponse(
          success: false,
          message: 'Unable to load categories at this time',
          data: [],
        );
      }

      if (response.data == null ||
          (response.data is List && response.data.isEmpty)) {
        return ApiResponse(
          success: true,
          message: 'No categories available',
          data: [],
        );
      }

      final categories = (response.data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      return ApiResponse(
        success: true,
        message: 'Categories fetched successfully',
        data: categories,
      );
    } catch (e) {
      Logger.error('Get categories error:', e);
      return ApiResponse(
        success: false,
        message: 'Unable to load categories at this time',
        data: [],
      );
    }
  }

  @override
  Future<ApiResponse<List<GetAllEventModel>>> getEventsByCategory(
      String category) async {
    try {
      final endpoint =
          '${ApiEndpoints.eventBaseUrl}${ApiEndpoints.getAllEvents}?category=$category';

      final response = await networkService.dio
          .get(
            endpoint,
            options: await getRequestOptions(),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw AppError(
          userMessage: 'Failed to fetch events',
          technicalMessage:
              'Status: ${response.statusCode}, Data: ${response.data}',
          type: ErrorType.server,
        );
      }

      if (response.data == null) {
        return ApiResponse.success(
          message: 'No events found',
          data: [],
        );
      }

      final eventsList = response.data as List;
      final mappedEvents =
          eventsList.map((json) => GetAllEventModel.fromJson(json)).toList();

      return ApiResponse.success(
        message: 'Events fetched successfully',
        data: mappedEvents,
      );
    } catch (e) {
      if (e is DioException) {
        throw AppError(
          userMessage: 'Network error while fetching events',
          technicalMessage: e.toString(),
          type: ErrorType.network,
        );
      }
      rethrow;
    }
  }

  double _calculateDistance(
      double userLat, double userLon, double eventLat, double eventLon) {
    return Geolocator.distanceBetween(
          userLat,
          userLon,
          eventLat,
          eventLon,
        ) /
        1000; // Convert meters to kilometers
  }

  @override
  Future<ApiResponse<List<GetAllEventModel>>> getNearbyEvents(
      {required double latitude,
      required double longitude,
      double radius = 5.0}) async {
    try {
      // Get all events first
      final allEventsResponse = await getAllEvents();

      if (allEventsResponse.data == null) {
        return ApiResponse.success(
          message: 'No nearby events found',
          data: [],
        );
      }

      // Filter events by distance
      final nearbyEvents = allEventsResponse.data!.where((event) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          event.latitude,
          event.longitude,
        );
        return distance <= radius;
      }).toList();

      Logger.debug(
          'Found ${nearbyEvents.length} events within ${radius}km radius');

      return ApiResponse.success(
        message: nearbyEvents.isEmpty
            ? 'No events found nearby'
            : 'Nearby events fetched successfully',
        data: nearbyEvents,
      );
    } catch (e) {
      Logger.error('Get nearby events error:', e);
      if (e is DioException) {
        throw AppError(
          userMessage: 'Network error while fetching nearby events',
          technicalMessage: e.toString(),
          type: ErrorType.network,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ApiResponse<List<GetAllEventModel>>> getTrendingEvents() async {
    try {
      final endpoint =
          '${ApiEndpoints.eventBaseUrl}${ApiEndpoints.getAllEvents}';

      final response = await networkService.dio
          .get(
            endpoint,
            options: await getRequestOptions(),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw AppError(
          userMessage: 'Failed to fetch trending events',
          technicalMessage:
              'Status: ${response.statusCode}, Data: ${response.data}',
          type: ErrorType.server,
        );
      }

      if (response.data == null) {
        return ApiResponse.success(
          message: 'No trending events found',
          data: [],
        );
      }

      final eventsList = response.data as List;
      final mappedEvents =
          eventsList.map((json) => GetAllEventModel.fromJson(json)).toList();

      return ApiResponse.success(
        message: 'Trending events fetched successfully',
        data: mappedEvents,
      );
    } catch (e) {
      if (e is DioException) {
        throw AppError(
          userMessage: 'Network error while fetching trending events',
          technicalMessage: e.toString(),
          type: ErrorType.network,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ApiResponse<List<GetAllEventModel>>> searchEvents(String query) async {
    try {
      // Instead of making a separate API call, we'll filter the existing events
      final allEventsResponse = await getAllEvents();

      if (allEventsResponse.data == null) {
        return ApiResponse.success(
          message: 'No events found matching your search',
          data: [],
        );
      }

      final searchQuery = query.toLowerCase();
      final filteredEvents = allEventsResponse.data!.where((event) {
        return event.title.toLowerCase().contains(searchQuery) ||
            event.description.toLowerCase().contains(searchQuery) ||
            event.category.toLowerCase().contains(searchQuery) ||
            event.type.toLowerCase().contains(searchQuery) ||
            event.city.toLowerCase().contains(searchQuery);
      }).toList();

      Logger.debug(
          'Found ${filteredEvents.length} events matching query: $query');

      return ApiResponse.success(
        message: filteredEvents.isEmpty
            ? 'No events found matching your search'
            : 'Search results fetched successfully',
        data: filteredEvents,
      );
    } catch (e) {
      Logger.error('Search events error:', e);
      if (e is DioException) {
        throw AppError(
          userMessage: 'Network error while searching events',
          technicalMessage: e.toString(),
          type: ErrorType.network,
        );
      }
      rethrow;
    }
  }
}
