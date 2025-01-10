import '../entities/get_event_entite.dart';
import '../repositories/event_repository.dart';

class GetEventsByCategoryUseCase {
  final EventRepositoryDomain repository;

  GetEventsByCategoryUseCase(this.repository);

  Future<List<GetAllEventEntities>> call(String category) {
    return repository.getEventsByCategory(category);
  }
}
