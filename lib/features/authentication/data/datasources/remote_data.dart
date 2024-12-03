import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flareup/core/constants/api_constants.dart';
import 'package:flareup/features/authentication/data/models/user_model_signup.dart';

import '../models/otp_model.dart';
import '../models/user_model_signin.dart';

class UserRemoteDatasource {
  late final Dio dio;

  UserRemoteDatasource() {
    dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';

    if (!const bool.fromEnvironment('dart.vm.product')) {
      // Development-only certificate handling
      (dio.httpClientAdapter as IOHttpClientAdapter).validateCertificate =
          (cert, host, port) {
        // TODO: Add proper certificate validation logic
        // For development, you might want to:
        // 1. Validate against specific known certificates
        // 2. Check certificate fingerprints
        // 3. Verify certificate chain
        return true; // Still unsafe, but at least confined to development
      };
    } else {
      // Production certificate handling
      (dio.httpClientAdapter as IOHttpClientAdapter).validateCertificate =
          (cert, host, port) {
        // Proper certificate validation
        final isValidHost = cert?.subject.contains(host) ?? false;
        final isValidIssuer =
            cert?.issuer.contains("YourExpectedIssuer") ?? false;
        final isNotExpired = cert?.endValidity.isAfter(DateTime.now()) ?? false;

        return isValidHost && isValidIssuer && isNotExpired;
      };
    }
  }

  Future<UserModelSignIn> login(
      {required String username, required String password}) async {
    try {
      dio.options.headers['Content-Type'] = 'application/json';
      print('Logging in with username: $username and password: $password');
      print('Request URL: ${ApiEndpoints.baseUrl + ApiEndpoints.login}');
      print('Request Headers: ${dio.options.headers}');
      print(
          'Request Body: { "username": "$username", "password": "$password" }');
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.login,
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
      // Set proper headers
      dio.options.headers['Content-Type'] = 'application/json';

      // Log request details for debugging
      print(
          'Attempting signup with endpoint: ${ApiEndpoints.baseUrl}${ApiEndpoints.signUp}');
      print(
          'Request payload: {username: $username, fullname: $fullName, email: $email, role: $role}');

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

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 201) {
        return UserModelSignup(
          userName: username,
          fullName: fullName,
          email: email,
          password: password,
          role: role,
        );
      }

      // Handle non-201 responses
      if (response.data is Map) {
        throw Exception(
            'Signup failed: ${response.data['message'] ?? 'Unknown error'}');
      } else {
        throw Exception('Signup failed: Unexpected response format');
      }
    } on DioException catch (e) {
      // Better error handling for Dio exceptions
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'Cannot connect to server. Please check if the server is running.');
      }

      final errorMessage = e.response?.data is Map
          ? e.response?.data['message'] ?? e.message
          : 'Connection error. Please check your server configuration.';
      throw Exception('Signup failed: $errorMessage');
    } catch (e) {
      throw Exception('Unexpected error during signup: $e');
    }
  }

  Future<OtpModel> sendOtp({required String email, required String otp}) async {
    try {
      print('Attempting to send OTP verification for email: $email');
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.otpVerification,
        data: {'email': email, 'enteredOtp': otp},
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OtpModel(email: email, otp: otp);
      }

      // Handle different error cases
      if (response.statusCode == 400) {
        final data = response.data;
        if (data is Map) {
          if (data.containsKey('email')) {
            throw Exception('Please restart the verification process');
          }
          if (data.containsKey('message')) {
            throw Exception(data['message']);
          }
        }
        throw Exception('Invalid OTP code');
      }

      throw Exception('Please try again');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Please try again');
    }
  }

  Future<void> resendOtp({required String email}) async {
    try {
      print('Attempting to resend OTP for email: $email');
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.resendOtp,
        data: {'email': email},
        options: Options(
          validateStatus: (status) =>
              status! < 500, // Accept both 2xx and 4xx responses
        ),
      );

      print('Resend OTP response status code: ${response.statusCode}');
      print('Resend OTP response data: ${response.data}');

      if (response.statusCode == 400 &&
          response.data['error']?.contains('cache') == true) {
        // Handle cache-specific error
        throw Exception('Session expired. Please go back and try again.');
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMessage = response.data['error'] ??
            response.data['message'] ??
            'Failed to resend OTP';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error during OTP resend: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          throw Exception(
              'Session expired. Please restart the signup process.');
        }
      }
      throw Exception('Failed to resend OTP. Please try again.');
    }
  }

  Future<void> logout() async {
    try {
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.logout,
      );

      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Logout request failed: $e');
    }
  }

  Future<UserModelSignIn> googleSignIn({required String accessToken}) async {
    return _handleGoogleAuth(
      accessToken: accessToken,
      isRegistration: false,
    );
  }

  Future<UserModelSignIn> googleSignUp({
    required String accessToken,
    required String role,
  }) async {
    return _handleGoogleAuth(
      accessToken: accessToken,
      isRegistration: true,
      role: role,
    );
  }

  Future<UserModelSignIn> _handleGoogleAuth({
    required String accessToken,
    required bool isRegistration,
    String? role,
  }) async {
    try {
      print('\n=== Starting Backend Google Auth Request ===');
      print('Endpoint: ${ApiEndpoints.baseUrl + ApiEndpoints.googleAuth}');

      final Map<String, dynamic> requestBody = {
        'gToken': accessToken,
      };

      // Only include role for registration
      if (isRegistration && role != null) {
        requestBody['role'] = role ?? 'user';
      }

      print('Request Body: $requestBody');

      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.googleAuth,
        data: requestBody,
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('\n=== Backend Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        return UserModelSignIn.fromJson(response.data);
      }

      // Handle registration required case
      if (response.statusCode == 401 &&
          response.data['error']
                  ?.toString()
                  .toLowerCase()
                  .contains('please register') ==
              true) {
        throw Exception('REGISTRATION_REQUIRED');
      }

      throw Exception(response.data['error'] ?? 'Authentication failed');
    } on DioException catch (e) {
      print('\n=== DioException Details ===');
      print('Error Type: ${e.type}');
      print('Error Message: ${e.message}');
      print('Response Status: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');

      final errorMessage = e.response?.data['error'] ?? 'Server error';
      throw Exception(errorMessage);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.forgotPassword,
        data: {'email': email},
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      print('\nResponse Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Success case - return normally
        return;
      }

      throw Exception(response.data['message'] ?? 'Failed to process request');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      print('\n=== Reset Password Request ===');
      print('Email: $email');
      print('Endpoint: ${ApiEndpoints.baseUrl + ApiEndpoints.setNewPassword}');
      print('Request Body: {email: $email, newPassword: $newPassword}');

      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.setNewPassword,
        data: {
          'email': email,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      print('\nResponse Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        return; // Success case
      }

      final errorMessage = response.data['message'] ?? 
                          response.data['error'] ?? 
                          'Failed to reset password';
      throw Exception(errorMessage);
    } catch (e) {
      print('\nError in reset password: $e');
      if (e is DioException) {
        print('Response data: ${e.response?.data}');
      }
      throw Exception('Failed to reset password. Please try again.');
    }
  }

  Future<void> verifyOtpForgotPassword({
    required String email,
    required String otp,
  }) async {
    try {
      print('\n=== Verifying OTP for Password Reset ===');
      print('Email: $email');
      print('OTP: $otp');
      print(
          'Endpoint: ${ApiEndpoints.baseUrl + ApiEndpoints.verifyOtpForgotPassword}');

      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.verifyOtpForgotPassword,
        data: {
          'email': email,
          'enteredOtp': otp,
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      print('\nResponse Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 202) {
        final errorMessage = response.data['error'] ??
            response.data['message'] ??
            'Failed to verify OTP';
        print('\nError: $errorMessage');
        throw Exception(errorMessage);
      }

      print('\nOTP verification successful');
    } catch (e) {
      print('\n=== OTP Verification Error ===');
      if (e is DioException) {
        print('Dio Error Type: ${e.type}');
        print('Error Message: ${e.message}');
        print('Response Status: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');

        if (e.response?.statusCode == 400) {
          final errorMessage = e.response?.data['error'] ??
              e.response?.data['message'] ??
              'Invalid OTP';
          throw Exception(errorMessage);
        }
      }
      // Propagate the original error if it's already an Exception
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to verify OTP. Please try again.');
    }
  }
}
