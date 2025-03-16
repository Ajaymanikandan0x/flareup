import '../../../home/domain/entities/get_event_entite.dart';
import '../repositories/event_repository.dart';

class GetEventUseCase {
  final SingleEventRepository repository;

  GetEventUseCase(this.repository);

  Future<GetAllEventEntities> call(int eventId) {
    return repository.getEventById(eventId);
  }
}
