import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'app_error.dart';

class ErrorHandler {
  static AppError handle(dynamic error, {String? customUserMessage}) {
    if (error is AppError) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is SocketException) {
      return AppError(
        userMessage: ErrorMessages.networkError,
        technicalMessage: 'No internet connection',
        type: ErrorType.network,
      );
    }

    if (error is TimeoutException) {
      return AppError(
        userMessage: 'Request timed out',
        technicalMessage: 'Operation timed out',
        type: ErrorType.network,
      );
    }

    return AppError(
      userMessage: customUserMessage ?? 'An unexpected error occurred',
      technicalMessage: error.toString(),
      type: ErrorType.unknown,
    );
  }

  static AppError _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return AppError(
          userMessage: 'Connection timed out',
          technicalMessage: e.message,
          type: ErrorType.network,
        );
      case DioExceptionType.connectionError:
        return AppError(
          userMessage: ErrorMessages.networkError,
          technicalMessage: e.message,
          type: ErrorType.network,
        );
      case DioExceptionType.receiveTimeout:
        return AppError(
          userMessage: 'Server not responding',
          technicalMessage: e.message,
          type: ErrorType.server,
        );
      default:
        return AppError(
          userMessage: 'Operation failed',
          technicalMessage: e.message,
          type: ErrorType.unknown,
        );
    }
  }
}
