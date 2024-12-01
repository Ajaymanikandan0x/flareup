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
  Future<UserEntitySignIn> googleAuth({required String accessToken}) async {
    try {
      final responseModel = await remoteDatasource.googleAuth(accessToken: accessToken);
      return responseModel.toEntity();
    } catch (e) {
      throw Exception('Google authentication failed: $e');
    }
  }
}
