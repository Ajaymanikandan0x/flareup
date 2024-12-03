import 'package:flareup/features/authentication/domain/entities/otp_entities.dart';

import '../entities/user_entities_signup.dart';
import '../entities/user_model_signin.dart';

abstract class AuthRepositoryDomain {
  Future<UserEntitySignIn> login(
      {required String username, required String password});
  Future<UserEntitiesSignup> signup({
    required String username,
    required String fullName,
    required String role,
    required String email,
    required String password,
  });
  Future<OtpEntity> sendOtp({required String email, required String otp});
  Future<void> logout();
  Future<void> resendOtp({required String email});

  // Future<UserEntitySignIn> googleAuth({required String accessToken});
  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  });
  Future<void> verifyOtpForgotPassword({
    required String email,
    required String otp,
  });
  Future<UserEntitySignIn> googleSignIn({required String accessToken});
  Future<UserEntitySignIn> googleSignUp({
    required String accessToken,
    required String role,
  });

}
