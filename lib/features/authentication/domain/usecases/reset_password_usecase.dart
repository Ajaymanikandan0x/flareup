import '../repositories/auth_repo_domain.dart';

class ResetPasswordUseCase {
  final AuthRepositoryDomain repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call({
    required String email,
    required String newPassword,
    required String otp,
  }) {
    return repository.resetPassword(
      email: email,
      newPassword: newPassword,
      otp: otp,
    );
  }
}