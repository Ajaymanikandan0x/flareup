import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/user_profile_model.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/network/dio_interceptor.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> fetchUserProfile(String userId);
  Future<void> updateUserProfile(UserProfileModel userProfile, {bool onlyProfileImage = false});
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final Dio dio;
  final SecureStorageService storageService;

  UserProfileRemoteDataSourceImpl(SecureStorageService storageService)
      : dio = Dio()..interceptors.add(AuthInterceptor(storageService, Dio())),
        storageService = storageService;

  @override
  Future<UserProfileModel> fetchUserProfile(String userId) async {
    try {
      final int numericId = int.parse(userId);
      final endpoint = ApiEndpoints.baseUrl + ApiEndpoints.user.replaceAll('user_id', numericId.toString());
      
      print('Fetching user profile from: $endpoint');
      final response = await dio.get(endpoint);
      
      if (response.statusCode == 200) {
        final data = response.data;
        print('Received user data: $data');
        
        return UserProfileModel.fromJson(data);
      } else {
        throw Exception('Failed to load user profile: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel userProfile, {bool onlyProfileImage = false}) async {
    try {
      final token = await storageService.getAccessToken();
      final endpoint = ApiEndpoints.baseUrl + 
          ApiEndpoints.updateUserProfile.replaceAll('user_id', userProfile.id.toString());
      
      final data = userProfile.toJson(onlyProfileImage: onlyProfileImage);
      print('Profile update endpoint: $endpoint');
      print('Profile update data: $data');
      print('onlyProfileImage flag: $onlyProfileImage');
      
      print('Sending data: ${data}');
      final response = await dio.patch(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('Received response: ${response.data}');
      
      print('Profile update response status: ${response.statusCode}');
      print('Profile update response data: ${response.data}');
      
      if (response.statusCode != 200 && response.statusCode != 202) {
        final errorMessage = response.data is Map ? 
            response.data['message'] ?? 'Unknown error' :
            'Server error: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      if (e is TypeError) {
        print('Type error in data handling');
      }
      rethrow;
    }
  }
}
