

import '../entities/user_model_signin.dart';
import '../repositories/auth_repo_domain.dart';

class LoginUseCase {
  final AuthRepositoryDomain authRepository;

  LoginUseCase(this.authRepository);

  Future<UserEntitySignIn> call(String email, String password) {
    return authRepository.login(email, password);
  }
}
