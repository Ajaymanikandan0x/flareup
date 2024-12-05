enum ErrorType {
  network,
  authentication,
  validation,
  server,
  unknown,
  businessLogic
}

class AppError implements Exception {
  final String userMessage;
  final String? technicalMessage;
  final ErrorType type;
  final String? errorCode;
  final Map<String, dynamic>? metadata;

  AppError({
    required this.userMessage,
    this.technicalMessage,
    required this.type,
    this.errorCode,
    this.metadata,
  });

  @override
  String toString() {
    return 'AppError: {type: $type, userMessage: $userMessage, technicalMessage: $technicalMessage, errorCode: $errorCode}';
  }
}

class ErrorMessages {
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Service temporarily unavailable';
  static const String sessionExpired = 'Session expired. Please login again';
  static const String invalidCredentials = 'Invalid username or password';
  static const String invalidOtp = 'Invalid OTP code';
} 