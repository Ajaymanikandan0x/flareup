import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/constants.dart';
import '../storage/secure_storage_service.dart';

enum UploadType { profile, event, video }

class CloudinaryService {
  final Dio _dio;
  final SecureStorageService _storageService;
  static const String _cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/upload';

  CloudinaryService(this._storageService) : _dio = Dio();

  Future<String?> uploadFile(File file, UploadType type) async {
    try {
      print('=== CloudinaryService.uploadFile ===');
      print('File path: ${file.path}');
      print('File exists: ${await file.exists()}');
      print('File size: ${await file.length()} bytes');
      print('Upload type: $type');
      
      // Add timeout to connectivity check
      final connectivityCheck = InternetAddress.lookup('api.cloudinary.com')
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException('Connection check timed out'),
          );
      
      try {
        final result = await connectivityCheck;
        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          throw Exception('No internet connection');
        }
      } catch (e) {
        if (e is TimeoutException) {
          print('Connection check timed out, attempting upload anyway...');
        } else if (e is SocketException) {
          print('Socket exception during connection check, attempting upload anyway...');
        } else {
          print('Connection check error: $e');
        }
        // Continue with upload attempt even if connectivity check fails
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': cloudinaryUploadPreset,
        'folder': _getFolderName(type),
      });

      print('\nSending request to Cloudinary...');
      final response = await _dio.post(
        _cloudinaryUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => true,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException('Upload request timed out'),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final secureUrl = response.data['secure_url'] as String?;
        if (secureUrl != null) {
          print('Upload successful: $secureUrl');
          return secureUrl;
        }
      }

      throw Exception('Upload failed: ${_parseErrorMessage(response.data)}');
    } on TimeoutException catch (e) {
      print('Timeout error: $e');
      throw Exception('Upload timed out. Please try again.');
    } on DioException catch (e) {
      print('\nDio error: ${e.type} - ${e.message}');
      String errorMessage = 'Upload failed';
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timed out';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Connection error - please check your internet';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Server not responding';
          break;
        default:
          errorMessage = e.message ?? 'Unknown error occurred';
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('\nUnexpected error: $e');
      throw Exception('Failed to upload image: $e');
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
