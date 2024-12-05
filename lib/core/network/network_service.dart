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

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ApiResponse.success(
          data: transform(response.data),
          message: response.data['message'],
          statusCode: response.statusCode,
        );
      }

      final errorMessage = response.data['message'] ?? 'Operation failed';
      return ApiResponse.error(
        message: errorMessage,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['message'] != null) {
        return ApiResponse.error(
          message: e.response?.data['message'],
          statusCode: e.response?.statusCode,
        );
      }
      throw AppError(
        userMessage: 'Operation failed',
        technicalMessage: e.toString(),
        type: ErrorType.network,
      );
    }
  }
}
