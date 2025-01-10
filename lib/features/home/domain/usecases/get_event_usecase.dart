import '../entities/get_event_entite.dart';
import '../repositories/event_repository.dart';

class GetAllEventsUseCase {
  final EventRepositoryDomain repository;

  GetAllEventsUseCase(this.repository);

  Future<List<GetAllEventEntities>> call() {
    return repository.getAllEvents();
  }
}
