import 'package:dio/dio.dart';
import 'package:flareup/core/constants/api_constants.dart';
import 'package:flareup/features/authentication/data/models/user_model_signup.dart';

import '../models/otp_model.dart';
import '../models/user_model_signin.dart';

class UserRemoteDatasource {
  final dio = Dio();

  Future<UserModelSignIn> login(
      {required String username, required String password}) async {
    try {
      // dio.options.headers['Content-Type'] = 'application/json';
      // print('Logging in with username: $username and password: $password');
      // print('Request URL: ${ApiEndpoints.baseUrl + ApiEndpoints.login}');
      // print('Request Headers: ${dio.options.headers}');
      // print('Request Body: { "username": "$username", "password": "$password" }');
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.data}');

      if (response.statusCode == 200) {
        return UserModelSignIn.fromJson(response.data);
      } else {
        print('Response body: ${response.data}');
        throw Exception(
            'Login failed: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModelSignup> signUp({
    required String username,
    required String fullName,
    required String password,
    required String email,
    required String role,
  }) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.signUp}',
        data: {
          'username': username,
          'fullname': fullName,
          'email': email.trim(),
          'phone_number': '1234567899', // Sample phone number
          'role': 'user',
          'password': password,
        },
      );
      if (response.statusCode == 201) {
        return UserModelSignup(
          userName: username,
          fullName: fullName,
          email: email,
          password: password,
          role: role,
        );
      }
      throw Exception(
          'Signup failed: Unexpected status code ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Signup failed: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<OtpModel> sendOtp({required String email, required String otp}) async {
    try {
      print('Attempting to send OTP verification for email: $email');
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.otpVerification,
        data: {'email': email, 'enteredOtp': otp},
      );

      print('OTP verification response status code: ${response.statusCode}');
      print('OTP verification response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('OTP verification successful');
        // Return the OTP model with the data we sent
        return OtpModel(email: email, otp: otp);
        //  return OtpModel.fromJson(response.data);
      }
      print('OTP verification failed with status code: ${response.statusCode}');
      throw Exception('Failed to verify OTP: Status code ${response.statusCode}');
    } catch (e) {
      print('Error during OTP verification: $e');
      throw Exception('OTP verification failed: $e');
    }
  }

  Future<void> resendOtp({required String email}) async {
    try {
      print('Attempting to resend OTP for email: $email');
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.resendOtp,
        data: {'email': email},
      );

      print('Resend OTP response status code: ${response.statusCode}');
      print('Resend OTP response data: ${response.data}');

      if (response.statusCode != 200) {
        print('Resend OTP failed with status code: ${response.statusCode}');
        throw Exception('Failed to resend OTP: Status code ${response.statusCode}');
      }
      print('OTP resent successfully');
    } catch (e) {
      print('Error during OTP resend: $e');
      throw Exception('Resend OTP failed: $e');
    }
  }
}
