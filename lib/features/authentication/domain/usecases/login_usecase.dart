import '../entities/user_model_signin.dart';
import '../repositories/auth_repo_domain.dart';

class LoginUseCase {
  final AuthRepositoryDomain authRepository;

  LoginUseCase(this.authRepository);

  Future<UserEntitySignIn> call(String username, String password) {
    return authRepository.login(username, password);
  }
}
