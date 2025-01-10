import '../entities/get_event_entite.dart';
import '../repositories/event_repository.dart';

class GetNearbyEventsUseCase {
  final EventRepositoryDomain repository;

  GetNearbyEventsUseCase(this.repository);

  Future<List<GetAllEventEntities>> call({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) {
    return repository.getNearbyEvents(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }
}
