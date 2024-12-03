import '../repositories/auth_repo_domain.dart';

class VerifyResetPasswordOtpUseCase {
  final AuthRepositoryDomain repository;

  VerifyResetPasswordOtpUseCase(this.repository);

  Future<void> call({required String email, required String otp}) {
    return repository.verifyOtpForgotPassword(email: email, otp: otp);
  }
}