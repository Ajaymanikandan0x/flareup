import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/base_api_client.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/error/app_error.dart';
import '../models/payment_session_model.dart';

abstract class PaymentRemoteDataSource {
  Future<ApiResponse<Map<String, dynamic>>> createPaymentSession(
      PaymentSessionModel session);
  Future<ApiResponse<Map<String, dynamic>>> processPayment(
      String paymentIntentId);
}

class PaymentRemoteDataSourceImpl extends BaseApiClient
    implements PaymentRemoteDataSource {
  PaymentRemoteDataSourceImpl(
    NetworkService networkService,
    SecureStorageService storageService,
  ) : super(networkService, storageService);

  @override
  Future<ApiResponse<Map<String, dynamic>>> createPaymentSession(
      PaymentSessionModel session) async {
    try {
      final endpoint = '${ApiEndpoints.baseUrl}${ApiEndpoints.paymentSession}';

      final response = await networkService.dio.post(
        endpoint,
        data: session.toJson(),
        options: await getRequestOptions(),
      );

      return ApiResponse.success(
        data: response.data,
        message: 'Payment session created successfully',
      );
    } catch (e) {
      if (e is DioException) {
        throw AppError(
          userMessage: 'Failed to create payment session',
          technicalMessage: e.toString(),
          type: ErrorType.network,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> processPayment(
      String paymentIntentId) async {
    // Implementation of processPayment method
    throw UnimplementedError();
  }
}
