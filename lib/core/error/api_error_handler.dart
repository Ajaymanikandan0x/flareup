import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getUserFriendlyMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timed out. Please check your internet connection';
        case DioExceptionType.connectionError:
          return 'Unable to connect to server. Please try again later';
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        default:
          return 'An unexpected error occurred';
      }
    }
    return 'Something went wrong. Please try again';
  }

  static String _handleBadResponse(Response? response) {
    switch (response?.statusCode) {
      case 400:
        return _handleBadRequestError(response?.data);
      case 401:
        return 'Session expired. Please login again';
      case 403:
        return 'Access denied';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error. Please try again later';
      default:
        return 'An unexpected error occurred';
    }
  }

  static String _handleBadRequestError(dynamic data) {
    if (data is Map) {
      if (data.containsKey('email') && data['email'].contains('exists')) {
        return 'This email is already registered';
      }
      if (data.containsKey('message')) {
        return data['message'];
      }
    }
    return 'Invalid request. Please check your input';
  }
} 