import 'package:flareup/core/network/api_response.dart';

import '../models/all_event_model.dart';
import '../models/category_model.dart';

abstract class EventRemoteDataSource {
  Future<ApiResponse<List<GetAllEventModel>>> getAllEvents();
  Future<ApiResponse<List<CategoryModel>>> getEventCategories();
  Future<ApiResponse<List<GetAllEventModel>>> getEventsByCategory(
      String category, {String? subcategoryId});
  Future<ApiResponse<List<GetAllEventModel>>> getNearbyEvents({
    required double latitude,
    required double longitude,
    double radius = 5.0,
  });
  Future<ApiResponse<List<GetAllEventModel>>> getTrendingEvents();
  Future<ApiResponse<List<GetAllEventModel>>> searchEvents(String query);
}
