import '../repositories/auth_repo_domain.dart';

class ResendOtpUseCase {
  final AuthRepositoryDomain repository;

  ResendOtpUseCase(this.repository);

  Future<void> call({required String email}) {
    return repository.resendOtp(email: email);
  }
}