import 'package:dio/dio.dart';

import '../error/app_error.dart';

class ApiResponseHandler {
  static T handleResponse<T>({
    required Response response,
    required T Function(Map<String, dynamic>) onSuccess,
    String? customErrorMessage,
  }) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return onSuccess(response.data);
        
      case 400:
        throw AppError(
          userMessage: response.data['message'] ?? 'Invalid request',
          type: ErrorType.validation
        );
        
      case 401:
        throw AppError(
          userMessage: ErrorMessages.sessionExpired,
          type: ErrorType.authentication
        );
        
      case 500:
        throw AppError(
          userMessage: ErrorMessages.serverError,
          technicalMessage: response.data['message'],
          type: ErrorType.server
        );
        
      default:
        throw AppError(
          userMessage: customErrorMessage ?? ErrorMessages.serverError,
          technicalMessage: response.data.toString(),
          type: ErrorType.unknown
        );
    }
  }
} 