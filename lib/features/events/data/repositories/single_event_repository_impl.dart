import '../../../../core/utils/logger.dart';
import '../../domain/repositories/event_repository.dart';
import '../../../home/domain/entities/get_event_entite.dart';
import '../datasources/event_remote_datasource.dart';

class SingleEventRepositoryImpl implements SingleEventRepository {
  final SingleEventRemoteDataSource _remoteDataSource;

  SingleEventRepositoryImpl(this._remoteDataSource);

  @override
  Future<GetAllEventEntities> getEventById(int eventId) async {
    try {
      Logger.debug('Repository: Fetching event with ID: $eventId');
      final response = await _remoteDataSource.getEventById(eventId);
      Logger.debug('Repository: Event fetched successfully');
      return response.toEntity();
    } catch (e, stackTrace) {
      Logger.error('Repository: Error fetching event:', e);
      Logger.error('Repository: Stack trace:', stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateTicketCount(int eventId, int count) async {
    try {
      Logger.debug(
          'Repository: Updating ticket count for event $eventId to $count');
      await _remoteDataSource.updateTicketCount(eventId, count);
      Logger.debug('Repository: Ticket count updated successfully');
    } catch (e) {
      Logger.error('Repository: Error updating ticket count:', e);
      rethrow;
    }
  }
}
