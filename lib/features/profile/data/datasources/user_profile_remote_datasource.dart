import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> fetchUserProfile(String userId);
  Future<void> updateUserProfile(UserProfileModel userProfile,
      {bool onlyProfileImage = false});
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final Dio dio;
  final SecureStorageService storageService;

  UserProfileRemoteDataSourceImpl({
    required this.storageService,
    required this.dio,
  });

  @override
  Future<UserProfileModel> fetchUserProfile(String userId) async {
    try {
      Logger.debug('Fetching profile for user ID: $userId');
      int retryCount = 0;
      const maxRetries = 3;

      while (retryCount < maxRetries) {
        try {
          final token = await storageService.getAccessToken();

          if (token == null) {
            await Future.delayed(
                Duration(milliseconds: 500 * (retryCount + 1)));
            retryCount++;
            continue;
          }

          final int numericId = int.parse(userId);
          final endpoint = ApiEndpoints.baseUrl +
              ApiEndpoints.user.replaceAll('user_id', numericId.toString());

          final response = await dio.get(
            endpoint,
            options: Options(
              validateStatus: (status) => status! < 500,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            ),
          );

          if (response.statusCode == 401) {
            await Future.delayed(
                Duration(milliseconds: 500 * (retryCount + 1)));
            retryCount++;
            continue;
          }

          if (response.statusCode == 404) {
            throw AppError(
                userMessage: 'User profile not found',
                technicalMessage: 'User ID $numericId not found in the system',
                type: ErrorType.businessLogic);
          }

          if (response.statusCode != 200) {
            throw AppError(
                userMessage: 'Failed to load profile',
                technicalMessage:
                    'Status ${response.statusCode}: ${response.data}',
                type: ErrorType.server);
          }

          return UserProfileModel.fromJson(response.data);
        } catch (e) {
          if (retryCount == maxRetries - 1) rethrow;
          retryCount++;
          await Future.delayed(Duration(milliseconds: 500 * retryCount));
        }
      }

      throw AppError(
          userMessage: 'Failed to load profile after multiple attempts',
          type: ErrorType.server);
    } catch (e) {
      Logger.error('Profile fetch error:', e);
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel userProfile,
      {bool onlyProfileImage = false}) async {
    try {
      await storageService.getAccessToken();
      final endpoint = ApiEndpoints.baseUrl +
          ApiEndpoints.updateUserProfile
              .replaceAll('user_id', userProfile.id.toString());

      final data = userProfile.toJson(onlyProfileImage: onlyProfileImage);
      Logger.debug('Profile update endpoint: $endpoint');
      Logger.debug('Profile update data: $data');

      final response = await dio.patch(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      Logger.debug('Response status code: ${response.statusCode}');
      Logger.debug('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 202) {
        return;
      } else {
        throw AppError(
          userMessage: 'Failed to update profile image',
          technicalMessage:
              'Status: ${response.statusCode}, Data: ${response.data}',
          type: ErrorType.server,
        );
      }
    } catch (e) {
      Logger.error('Detailed error in updateUserProfile:', e);
      rethrow;
    }
  }
}
