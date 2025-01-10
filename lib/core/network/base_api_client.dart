import 'package:dio/dio.dart';

import '../error/app_error.dart';
import '../storage/secure_storage_service.dart';
import '../utils/logger.dart';
import 'api_response.dart';
import 'network_service.dart';

class BaseApiClient {
  final NetworkService networkService;
  final SecureStorageService storageService;

  BaseApiClient(this.networkService, this.storageService);

  Future<Options> getRequestOptions() async {
    final token = await storageService.getAccessToken();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      validateStatus: (status) => status! < 500,
      responseType: ResponseType.json,
    );
  }

  Future<ApiResponse<T>> makeRequest<T>({
    required Future<Response> Function() request,
    required String successMessage,
    required String errorMessage,
    T Function(dynamic)? transform,
  }) async {
    try {
      final response = await request();
      Logger.debug('Response status code: ${response.statusCode}');
      Logger.debug('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _handleSuccessResponse(
          response: response,
          successMessage: successMessage,
          transform: transform,
        );
      }

      throw _createAppError(
        errorMessage: errorMessage,
        response: response,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      Logger.error('API request error:', e);
      rethrow;
    }
  }

  ApiResponse<T> _handleSuccessResponse<T>({
    required Response response,
    required String successMessage,
    T Function(dynamic)? transform,
  }) {
    try {
      final data = transform != null ? transform(response.data) : response.data;
      final message = response.data is Map ? 
          response.data['message'] ?? successMessage : 
          successMessage;
          
      return ApiResponse<T>(
        success: true,
        message: message,
        data: data,
      );
    } catch (e) {
      throw AppError(
        userMessage: 'Error processing server response',
        technicalMessage: e.toString(),
        type: ErrorType.server,
      );
    }
  }

  AppError _createAppError({
    required String errorMessage,
    required Response response,
  }) {
    return AppError(
      userMessage: errorMessage,
      technicalMessage: 'Status: ${response.statusCode}, Data: ${response.data}',
      type: ErrorType.server,
    );
  }

  AppError _handleDioError(DioException e) {
    Logger.error('API request error:', e);
    Logger.error('Response data:', e.response?.data);
    return AppError(
      userMessage: 'Failed to connect to server',
      technicalMessage: e.toString(),
      type: ErrorType.network,
    );
  }
} 