import 'package:dio/dio.dart';
import 'package:flareup/core/constants/api_constants.dart';
import 'package:flareup/features/authentication/data/models/user_model_signin.dart';
import 'package:flareup/features/authentication/data/models/user_model_signup.dart';

class UserRemoteDatasource {
  final dio = Dio();

  Future<UserModelSignIn> login(
      {required String username, required String password}) async {
    try {
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      return UserModelSignIn.fromJson(response.data);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModelSignup> signUp(
      {required String username,
      required String fullName,
      required String password,
      required String email,
      required String role}) async {
    try {
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.signUp,
        data: {
          'role': role,
          'fullName': fullName,
          'username': username,
          'password': password,
          'email': email
        },
      );
      return UserModelSignup.fromJson(response.data);
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }
}
