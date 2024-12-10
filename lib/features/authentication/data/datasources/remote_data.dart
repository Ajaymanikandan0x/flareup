import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flareup/core/constants/api_constants.dart';
import 'package:flareup/features/authentication/data/models/user_model_signup.dart';

import '../../../../core/error/app_error.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/network_service.dart';
import '../models/otp_model.dart';
import '../models/user_model_signin.dart';

import '../../../../core/utils/logger.dart';

class UserRemoteDatasource {
  final NetworkService _networkService;
  final Dio dio;

  UserRemoteDatasource(this._networkService) : dio = _networkService.dio {
    dio.options.headers['Content-Type'] = 'application/json';

    if (!const bool.fromEnvironment('dart.vm.product')) {
      // Development-only certificate handling
      (dio.httpClientAdapter as IOHttpClientAdapter).validateCertificate =
          (cert, host, port) {
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

  Future<ApiResponse<UserModelSignIn>> login({
    required String username,
    required String password,
  }) async {
    Logger.debug('Attempting login for user: $username');

    return _networkService.safeApiCall(
      apiCall: () => dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
        },
      ),
      transform: (data) => UserModelSignIn.fromJson(data),
    );
  }

  Future<ApiResponse<UserModelSignup>> signUp({
    required String username,
    required String fullName,
    required String password,
    required String email,
    required String role,
  }) async {
    Logger.debug('Attempting signup for user: $username');

    return _networkService.safeApiCall(
      apiCall: () => dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.signUp}',
        data: {
          'username': username,
          'fullname': fullName,
          'email': email.trim(),
          'phone_number': '1234567899',
          'role': role,
          'password': password,
        },
      ),
      transform: (data) {
        Logger.debug('Transform data: $data');
        return UserModelSignup.fromJson({
          ...data,
          'username': username,
          'fullname': fullName,
          'email': email,
          'role': role,
          'password': password,
        });
      },
    );
  }

  Future<ApiResponse<OtpModel>> sendOtp({
    required String email,
    required String otp,
  }) async {
    Logger.debug('Verifying OTP for email: $email');

    try {
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.otpVerification,
        data: {'email': email, 'enteredOtp': otp},
        options: Options(
          validateStatus: (status) => true,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      Logger.debug('OTP Response status: ${response.statusCode}');
      Logger.debug('OTP Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(
          data: OtpModel.fromJson(response.data, email: email, otp: otp),
          message: response.data['message'],
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode == 400) {
        final data = response.data;
        if (data is Map) {
          if (data['error']?.contains('cache') == true) {
            throw AppError(
              userMessage:
                  'Session expired. Please restart the signup process.',
              type: ErrorType.validation,
            );
          }
          if (data.containsKey('message')) {
            throw AppError(
              userMessage: data['message'],
              type: ErrorType.validation,
            );
          }
        }
        throw AppError(
          userMessage: 'Invalid OTP code',
          type: ErrorType.validation,
        );
      }

      throw AppError(
        userMessage: 'Verification failed. Please try again.',
        type: ErrorType.server,
      );
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        userMessage: 'Failed to verify OTP. Please try again.',
        technicalMessage: e.toString(),
        type: ErrorType.unknown,
      );
    }
  }

  Future<ApiResponse<void>> resendOtp({required String email}) async {
    Logger.debug('Resending OTP for email: $email');

    try {
      final response = await dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.resendOtp,
        data: {'email': email},
        options: Options(
          validateStatus: (status) => true,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      Logger.debug('Resend OTP Response status: ${response.statusCode}');

      // Handle HTML error response
      if (response.data is String &&
          response.data.toString().contains('<!DOCTYPE html>')) {
        throw AppError(
          userMessage:
              'Service temporarily unavailable. Please try again later.',
          type: ErrorType.server,
          technicalMessage: 'Server returned HTML instead of JSON',
        );
      }

      Logger.debug('Resend OTP Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(
          data: null,
          message: response.data['message'] ?? 'OTP sent successfully',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode == 400) {
        final data = response.data;
        if (data is Map && data['error']?.contains('cache') == true) {
          throw AppError(
            userMessage: 'Session expired. Please restart the signup process.',
            type: ErrorType.validation,
          );
        }
      }

      if (response.statusCode != null && response.statusCode! >= 500) {
        throw AppError(
          userMessage:
              'Service temporarily unavailable. Please try again later.',
          type: ErrorType.server,
          technicalMessage: 'Server error: ${response.statusCode}',
        );
      }

      throw AppError(
        userMessage: response.data['message'] ?? 'Failed to resend OTP',
        type: ErrorType.server,
      );
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError(
        userMessage: 'Failed to resend OTP. Please try again.',
        technicalMessage: e.toString(),
        type: ErrorType.unknown,
      );
    }
  }

  Future<ApiResponse<void>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    return _networkService.safeApiCall(
      apiCall: () => dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.setNewPassword,
        data: {
          'email': email,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
      ),
      transform: (_) {},
    );
  }

  Future<ApiResponse<void>> verifyOtpForgotPassword({
    required String email,
    required String otp,
  }) async {
    return _networkService.safeApiCall(
      apiCall: () => dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.verifyOtpForgotPassword,
        data: {
          'email': email,
          'enteredOtp': otp,
        },
      ),
      transform: (_) {},
    );
  }

  Future<ApiResponse<UserModelSignIn>> googleSignIn({
    required String accessToken,
  }) async {
    return _networkService.safeApiCall(
      apiCall: () => dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.googleAuth,
        data: {
          'gToken': accessToken,
        },
      ),
      transform: (data) => UserModelSignIn.fromJson(data),
    );
  }

  Future<ApiResponse<UserModelSignIn>> googleSignUp({
    required String accessToken,
    required String role,
  }) async {
    return _networkService.safeApiCall(
      apiCall: () => dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.googleAuth,
        data: {
          'gToken': accessToken,
          'role': role,
        },
      ),
      transform: (data) => UserModelSignIn.fromJson(data),
    );
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
}
