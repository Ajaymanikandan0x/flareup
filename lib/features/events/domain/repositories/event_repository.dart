import '../../../home/domain/entities/get_event_entite.dart';

abstract class SingleEventRepository {
  Future<GetAllEventEntities> getEventById(int eventId);
  Future<void> updateTicketCount(int eventId, int count);
}
