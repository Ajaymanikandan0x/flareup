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
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': cloudinaryUploadPreset,
        'folder': _getFolderName(type),
      });

      print('\nRequest Details:');
      print('URL: $_cloudinaryUrl');
      print('Upload preset: $cloudinaryUploadPreset');
      print('Folder: ${_getFolderName(type)}');
      print('Form data fields: ${formData.fields}');

      try {
        print('\nSending request to Cloudinary...');
        final response = await _dio.post(
          _cloudinaryUrl,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
            validateStatus: (status) => true, // Accept all status codes for debugging
          ),
        );

        print('\nResponse Details:');
        print('Status code: ${response.statusCode}');
        print('Headers: ${response.headers}');
        print('Response data: ${response.data}');

        if (response.statusCode == 200) {
          final secureUrl = response.data['secure_url'] as String?;
          print('\nSecure URL extracted: $secureUrl');
          return secureUrl;
        }

        // Detailed error logging
        print('\nError Response Analysis:');
        print('Response data type: ${response.data.runtimeType}');
        if (response.data is Map) {
          print('Error data structure: ${response.data.keys}');
          if (response.data['error'] != null) {
            print('Error content: ${response.data['error']}');
          }
        }

        throw Exception('Upload failed: ${_parseErrorMessage(response.data)}');
      } on DioException catch (e) {
        print('\nDio Exception Details:');
        print('Type: ${e.type}');
        print('Message: ${e.message}');
        print('Response: ${e.response?.data}');
        rethrow;
      }
    } catch (e, stackTrace) {
      print('\nError Details:');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to upload file: $e');
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
