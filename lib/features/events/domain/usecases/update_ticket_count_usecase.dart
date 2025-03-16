import '../repositories/event_repository.dart';

class UpdateTicketCountUseCase {
  final SingleEventRepository repository;

  UpdateTicketCountUseCase(this.repository);

  Future<void> call(int eventId, int count) {
    return repository.updateTicketCount(eventId, count);
  }
}
