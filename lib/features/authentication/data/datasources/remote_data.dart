import 'package:dio/dio.dart';
import 'package:flareup/core/constants/api_constants.dart';
import 'package:flareup/features/authentication/data/models/user_model_signup.dart';

import '../models/user_model_signin.dart';

class UserRemoteDatasource {
  final dio = Dio();

  Future<UserModelSignIn> login(
      {required String username, required String password}) async {
    try {
      dio.options.headers['Content-Type'] = 'application/json';
      print('Logging in with username: $username and password: $password');
      print('Request URL: ${ApiEndpoints.baseUrl + ApiEndpoints.login}');
      print('Request Headers: ${dio.options.headers}');
      print('Request Body: { "username": "$username", "password": "$password" }');
      final response = await dio.post(
        // ApiEndpoints.baseUrl + ApiEndpoints.login,
        'http://10.0.2.2:8081/login/',
        data: {
          'username': username,
          'password': password,
        },
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.data}');
      
      if (response.statusCode == 200) {
        return UserModelSignIn.fromJson(response.data);
      } else {
        print('Response body: ${response.data}');
        throw Exception('Login failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Error during login: $e');
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
