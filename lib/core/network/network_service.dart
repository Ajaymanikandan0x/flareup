import 'package:dio/dio.dart';

import '../error/app_error.dart';
import 'api_response.dart';

class NetworkService {
  final Dio dio;

  NetworkService(this.dio);

  Future<ApiResponse<T>> safeApiCall<T>({
    required Future<Response> Function() apiCall,
    required T Function(dynamic) transform,
  }) async {
    try {
      final response = await apiCall();
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(
          data: transform(response.data),
          message: response.data['message'] ?? 'Success',
          statusCode: response.statusCode,
        );
      }

      // Handle specific error cases
      if (response.statusCode == 401) {
        throw AppError(
          userMessage: 'Invalid username or password',
          type: ErrorType.authentication,
        );
      }

      if (response.statusCode == 400) {
        final message = response.data['message'] ?? 'Invalid request';
        throw AppError(
          userMessage: message,
          type: ErrorType.validation,
        );
      }

      throw AppError(
        userMessage: response.data['message'] ?? 'Operation failed',
        type: ErrorType.server,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw AppError(
          userMessage: 'Please check your internet connection',
          type: ErrorType.network,
        );
      }
      
      // Handle response errors
      if (e.response?.data != null) {
        final message = e.response?.data['message'] ?? 'Authentication failed';
        throw AppError(
          userMessage: message,
          type: ErrorType.authentication,
        );
      }
      
      throw AppError(
        userMessage: 'Unable to connect to server',
        type: ErrorType.network,
      );
    }
  }
}
