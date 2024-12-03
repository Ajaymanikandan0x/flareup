import '../repositories/auth_repo_domain.dart';

class ForgotPasswordUseCase {
  final AuthRepositoryDomain repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call({required String email}) {
    return repository.forgotPassword(email: email);
  }
}