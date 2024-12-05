class ApiResponse<T> {
  final T? data;
  final String? message;

  final bool success;
  final int? statusCode;

  ApiResponse({
    this.data,
    this.message,
  
    required this.success,
    this.statusCode,
  });

  factory ApiResponse.success({T? data, String? message, int? statusCode}) {
    return ApiResponse(
      data: data,
      message: message,
      success: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({String? message, int? statusCode}) {
    return ApiResponse(
      message: message,
      success: false,
      statusCode: statusCode,
    );
  }
} 