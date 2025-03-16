import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/base_api_client.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../home/data/models/all_event_model.dart';

abstract class SingleEventRemoteDataSource {
  Future<GetAllEventModel> getEventById(int eventId);
  Future<void> updateTicketCount(int eventId, int count);
}

class SingleEventRemoteDataSourceImpl extends BaseApiClient
    implements SingleEventRemoteDataSource {
  SingleEventRemoteDataSourceImpl(
    NetworkService networkService,
    SecureStorageService storageService,
  ) : super(networkService, storageService);

  @override
  Future<GetAllEventModel> getEventById(int eventId) async {
    try {
      Logger.debug('DataSource: Fetching event with ID: $eventId');
      final endpoint =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getAllEvents}/$eventId';

      final response = await networkService.dio.get(
        endpoint,
        options: await networkService.getRequestOptions(),
      );

      if (response.statusCode != 200) {
        Logger.debug('DataSource: Non-200 status code: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch event',
        );
      }

      if (response.data == null) {
        Logger.debug('DataSource: Null response data');
        throw Exception('Event data is null');
      }

      Logger.debug('DataSource: Raw response data: ${response.data}');
      return GetAllEventModel.fromJson(response.data);
    } catch (e, stackTrace) {
      Logger.error('DataSource: Error fetching event:', e);
      Logger.error('DataSource: Stack trace:', stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateTicketCount(int eventId, int count) async {
    try {
      final endpoint =
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getAllEvents}/$eventId/ticket-count';
      await networkService.dio.patch(
        endpoint,
        data: {'count': count},
        options: await networkService.getRequestOptions(),
      );
    } catch (e) {
      Logger.error('DataSource: Error updating ticket count:', e);
      rethrow;
    }
  }
}
