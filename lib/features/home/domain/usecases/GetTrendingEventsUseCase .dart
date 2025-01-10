import '../entities/get_event_entite.dart';
import '../repositories/event_repository.dart';

class GetTrendingEventsUseCase {
  final EventRepositoryDomain repository;

  GetTrendingEventsUseCase(this.repository);

  Future<List<GetAllEventEntities>> call() {
    return repository.getTrendingEvents();
  }
}
