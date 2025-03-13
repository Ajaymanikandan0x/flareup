import '../entities/category_entity.dart';
import '../entities/get_event_entite.dart';

abstract class EventRepositoryDomain {
  Future<List<GetAllEventEntities>> getAllEvents();
  Future<List<GetAllEventEntities>> getTrendingEvents();
  Future<List<GetAllEventEntities>> getNearbyEvents({
    required double latitude,
    required double longitude,
    double radius,
  });
  Future<List<GetAllEventEntities>> searchEvents(String query);
  Future<List<GetAllEventEntities>> getEventsByCategory(String categoryId, {String? subcategoryId});
  Future<List<CategoryEntity>> getCategories();
}
