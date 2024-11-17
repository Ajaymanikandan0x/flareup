import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> fetchUserProfile(String userId);
  Future<void> updateUserProfile(UserProfileModel userProfile);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final dio = Dio();

  @override
  Future<UserProfileModel> fetchUserProfile(String userId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.user + userId,
      );
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel userProfile) async {
    try {
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.user + userProfile.id,
        data: userProfile.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }
}
