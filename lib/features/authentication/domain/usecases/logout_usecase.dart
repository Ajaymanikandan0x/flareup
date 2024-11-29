import '../repositories/auth_repo_domain.dart';

class LogoutUseCase {
  final AuthRepositoryDomain authRepository;

  LogoutUseCase(this.authRepository);

  Future<void> call() {
    return authRepository.logout();
  }
}