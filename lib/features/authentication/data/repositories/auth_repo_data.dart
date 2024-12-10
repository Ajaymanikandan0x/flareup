import '../../../../core/error/app_error.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/otp_entities.dart';
import '../../domain/entities/user_entities_signup.dart';
import '../../domain/entities/user_model_signin.dart';
import '../../domain/repositories/auth_repo_domain.dart';
import '../datasources/remote_data.dart';
import '../../../../core/error/error_handler.dart';

class UserRepositoryImpl implements AuthRepositoryDomain {
  final UserRemoteDatasource _remoteDatasource;

  UserRepositoryImpl(this._remoteDatasource);

  @override
  Future<UserEntitySignIn> login(
      {required String username, required String password}) async {
    try {
      final response = await _remoteDatasource.login(
        username: username,
        password: password,
      );

      if (response.success) {
        final user = response.data!.toEntity();
        
        // Add role validation
        if (user.role != 'user') {
          throw AppError(
            userMessage: 'Access denied. Invalid user role.',
            type: ErrorType.authentication
          );
        }
        
        return user;
      }

      Logger.error('Login failed', {
        'statusCode': response.statusCode,
        'message': response.message,
        'data': response.data
      });

      throw AppError(
        userMessage: 'Incorrect username or password',
        technicalMessage: 'API Response: ${response.message}',
        type: ErrorType.authentication
      );
    } catch (e) {
      Logger.error('Login error', e);

      if (e is AppError) {
        Logger.error('AppError details', {
          'type': e.type,
          'technicalMessage': e.technicalMessage,
          'metadata': e.metadata
        });
        rethrow;
      }

      // For any other errors, show generic message but log full details
      throw AppError(
          userMessage: 'Unable to sign in. Please try again.',
          technicalMessage: e.toString(),
          type: ErrorType.authentication);
    }
  }

  @override
  Future<UserEntitiesSignup> signup({
    required String username,
    required String fullName,
    required String role,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDatasource.signUp(
        username: username,
        fullName: fullName,
        role: role,
        email: email,
        password: password,
      );

      if (response.success) {
        return UserEntitiesSignup(
          username: username,
          fullName: fullName,
          password: password,
          role: role,
          email: email,
        );
      }

      throw AppError(
        userMessage: response.message ?? 'Unable to create account',
        type: ErrorType.businessLogic,
      );
    } catch (e) {
      Logger.error('Repository signup error', e);
      throw ErrorHandler.handle(e,
          customUserMessage: 'Failed to create account');
    }
  }

  @override
  Future<OtpEntity> sendOtp({
    required String email,
    required String otp,
  }) async {
    try {
      Logger.debug('Repository: Sending OTP verification request');
      final response = await _remoteDatasource.sendOtp(
        email: email,
        otp: otp,
      );

      if (response.success) {
        Logger.debug('OTP verification successful');
        return response.data!.toEntity();
      }

      throw AppError(
        userMessage: response.message ?? 'Invalid OTP code',
        type: ErrorType.validation,
      );
    } on AppError catch (e) {
      if (e.type == ErrorType.validation) {}
      rethrow;
    } catch (e) {
      Logger.error('OTP verification failed with unexpected error', e);
      throw AppError(
        userMessage: 'Invalid OTP code. Please try again.',
        type: ErrorType.validation,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDatasource.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<void> resendOtp({required String email}) async {
    try {
      final response = await _remoteDatasource.resendOtp(email: email);

      if (!response.success) {
        throw AppError(
          userMessage: response.message ?? 'Failed to resend OTP',
          type: ErrorType.validation,
          technicalMessage: 'Status code: ${response.statusCode}',
        );
      }
    } on AppError {
      rethrow;
    } catch (e) {
      Logger.error('Resend OTP failed', e);
      throw AppError(
        userMessage: 'Unable to resend OTP. Please try again later.',
        technicalMessage: e.toString(),
        type: ErrorType.unknown,
      );
    }
  }

  @override
  Future<UserEntitySignIn> googleSignIn({required String accessToken}) async {
    final response = await _remoteDatasource.googleSignIn(
      accessToken: accessToken,
    );

    if (response.success) {
      return response.data!.toEntity();
    }
    throw Exception(response.message ?? 'Google sign in failed');
  }

  @override
  Future<UserEntitySignIn> googleSignUp({
    required String accessToken,
    required String role,
  }) async {
    final response = await _remoteDatasource.googleSignUp(
      accessToken: accessToken,
      role: role,
    );

    if (response.success) {
      return response.data!.toEntity();
    }
    throw Exception(response.message ?? 'Google sign up failed');
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _remoteDatasource.forgotPassword(email: email);
      return;
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '').trim();
      }
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    try {
      await _remoteDatasource.resetPassword(
        email: email,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  @override
  Future<void> verifyOtpForgotPassword({
    required String email,
    required String otp,
  }) async {
    final response = await _remoteDatasource.verifyOtpForgotPassword(
      email: email,
      otp: otp,
    );

    if (!response.success) {
      throw Exception(response.message ?? 'OTP verification failed');
    }
  }
}
