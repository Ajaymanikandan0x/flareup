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
      final int numericId = int.parse(userId);
      final endpoint = ApiEndpoints.baseUrl +
          ApiEndpoints.user.replaceAll('user_id', numericId.toString());

      Logger.debug('Fetching user profile from: $endpoint');
      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        Logger.debug('Received user data: $data');

        return UserProfileModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load user profile: Status ${response.statusCode}');
      }
    } on FormatException {
      throw Exception('Invalid user ID format');
    } catch (e) {
      Logger.error('Error fetching user profile:', e);
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
