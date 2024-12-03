import '../../domain/entities/otp_entities.dart';
import '../../domain/entities/user_entities_signup.dart';
import '../../domain/entities/user_model_signin.dart';
import '../../domain/repositories/auth_repo_domain.dart';
import '../datasources/remote_data.dart';

class UserRepositoryImpl implements AuthRepositoryDomain {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserEntitySignIn> login(
      {required String username, required String password}) async {
    try {
      final userModel =
          await remoteDatasource.login(username: username, password: password);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserEntitiesSignup> signup(
      {required String username,
      required String fullName,
      required String role,
      required String email,
      required String password}) async {
    try {
      final userModel = await remoteDatasource.signUp(
          fullName: fullName,
          email: email,
          role: role,
          username: username,
          password: password);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  @override
  Future<OtpEntity> sendOtp(
      {required String email, required String otp}) async {
    try {
      final otpModel = await remoteDatasource.sendOtp(email: email, otp: otp);
      return otpModel.toEntity();
    } catch (e) {
      throw Exception(' failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDatasource.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<void> resendOtp({required String email}) async {
    try {
      await remoteDatasource.resendOtp(email: email);
    } catch (e) {
      throw Exception('Resend OTP failed: $e');
    }
  }

  @override

  Future<UserEntitySignIn> googleSignIn({required String accessToken}) async {
    try {
      print('\n=== Repository: Starting Google Sign In ===');
      print('Token length: ${accessToken.length}');
      print('Token prefix: ${accessToken.substring(0, 10)}...');
      
      final responseModel = await remoteDatasource.googleSignIn(
        accessToken: accessToken,
      );
      print('Sign in successful, converting to entity...');
      return responseModel.toEntity();
    } catch (e, stackTrace) {
      print('\n=== Repository Error ===');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<UserEntitySignIn> googleSignUp({
    required String accessToken,
    required String role,
  }) async {
    try {
      final responseModel = await remoteDatasource.googleSignUp(
        accessToken: accessToken,
        role: role,
      );
      return responseModel.toEntity();
    } catch (e) {
      throw Exception('Google sign up failed: $e');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await remoteDatasource.forgotPassword(email: email);
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
      await remoteDatasource.resetPassword(
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
    try {
      await remoteDatasource.verifyOtpForgotPassword(
        email: email,
        otp: otp,
      );
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');

    }
  }
}
