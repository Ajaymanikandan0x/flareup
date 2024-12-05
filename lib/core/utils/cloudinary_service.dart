import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/constants.dart';
import '../error/app_error.dart';
import '../storage/secure_storage_service.dart';

enum UploadType { profile, event, video }

class CloudinaryService {
  final Dio _dio;
  final SecureStorageService _storageService;
  static const String _cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/upload';
  static const int _connectionTimeout = 5;
  static const int _uploadTimeout = 60;

  CloudinaryService(this._storageService) : _dio = Dio();

  Future<String?> uploadFile(File file, UploadType type) async {
    try {
      // Validate file
      if (!await file.exists()) {
        throw AppError(
          userMessage: 'File not found',
          technicalMessage: 'File does not exist at path: ${file.path}',
          type: ErrorType.validation,
        );
      }

      final fileSize = await file.length();
      if (fileSize > 10 * 1024 * 1024) { // 10MB limit
        throw AppError(
          userMessage: 'File size too large',
          technicalMessage: 'File size: ${fileSize / (1024 * 1024)}MB exceeds 10MB limit',
          type: ErrorType.validation,
        );
      }

      // Check connectivity with proper error handling
      try {
        await InternetAddress.lookup('api.cloudinary.com')
            .timeout(Duration(seconds: _connectionTimeout));
      } on SocketException {
        throw AppError(
          userMessage: ErrorMessages.networkError,
          technicalMessage: 'No internet connection',
          type: ErrorType.network,
        );
      } on TimeoutException {
        throw AppError(
          userMessage: 'Slow internet connection',
          technicalMessage: 'Connection check timed out after $_connectionTimeout seconds',
          type: ErrorType.network,
        );
      }

      // Prepare upload data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': cloudinaryUploadPreset,
        'folder': _getFolderName(type),
      });

      // Upload with progress tracking
      final response = await _dio.post(
        _cloudinaryUrl,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          validateStatus: (status) => true,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100).toStringAsFixed(2);
          print('Upload progress: $progress%');
        },
      ).timeout(
        Duration(seconds: _uploadTimeout),
        onTimeout: () {
          throw AppError(
            userMessage: 'Upload timed out',
            technicalMessage: 'Upload exceeded $_uploadTimeout seconds',
            type: ErrorType.network,
          );
        },
      );

      // Handle response
      if (response.statusCode == 200) {
        final secureUrl = response.data['secure_url'] as String?;
        if (secureUrl != null) {
          return secureUrl;
        }
      }

      throw AppError(
        userMessage: 'Failed to upload file',
        technicalMessage: _parseErrorMessage(response.data),
        type: ErrorType.server,
      );

    } on AppError {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppError(
        userMessage: 'Unexpected error occurred',
        technicalMessage: e.toString(),
        type: ErrorType.unknown,
      );
    }
  }

  AppError _handleDioError(DioException e) {
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
          userMessage: 'Upload failed',
          technicalMessage: e.message,
          type: ErrorType.unknown,
        );
    }
  }

  String _getFolderName(UploadType type) {
    switch (type) {
      case UploadType.profile:
        return 'profiles';
      case UploadType.event:
        return 'events';
      case UploadType.video:
        return 'videos';
    }
  }

  String _parseErrorMessage(dynamic responseData) {
    try {
      if (responseData is Map) {
        if (responseData['error'] is Map) {
          return responseData['error']['message'] ?? 'Unknown error';
        } else if (responseData['error'] is String) {
          return responseData['error'];
        }
      }
      return 'Unknown error format: $responseData';
    } catch (e) {
      return 'Error parsing response: $e';
    }
  }
}
