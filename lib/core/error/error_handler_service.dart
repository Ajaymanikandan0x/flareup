import '../utils/logger.dart';
import 'app_error.dart';

abstract class ErrorHandlerService {
  String getReadableError(Exception error);
  void logError(Exception error, StackTrace? stackTrace);
}

class AppErrorHandlerService implements ErrorHandlerService {
  final Logger? logger;

  AppErrorHandlerService({this.logger});

  @override
  String getReadableError(Exception error) {
    if (error is AppError) {
      switch (error.type) {
        case ErrorType.network:
          return ErrorMessages.networkError;
        case ErrorType.authentication:
          return ErrorMessages.invalidCredentials;
        case ErrorType.server:
          return ErrorMessages.serverError;
        case ErrorType.validation:
          return error.userMessage;
        default:
          return 'Something went wrong. Please try again.';
      }
    }
    return 'An unexpected error occurred';
  }

  @override
  void logError(Exception error, [StackTrace? stackTrace]) {
    if (error is AppError) {
      Logger.error('AppError', {
        'type': error.type,
        'userMessage': error.userMessage,
        'technicalMessage': error.technicalMessage,
        'metadata': error.metadata,
      });
    } else {
       Logger.error('Unexpected error', error, stackTrace);
    }
  }
} 