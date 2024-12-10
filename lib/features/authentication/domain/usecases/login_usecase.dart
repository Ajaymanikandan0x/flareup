import '../entities/user_model_signin.dart';
import '../repositories/auth_repo_domain.dart';

class LoginUseCase {
  final AuthRepositoryDomain authRepository;

  LoginUseCase(this.authRepository);

  Future<UserEntitySignIn> call(
      {required String username, required String password}) {
    return authRepository.login(username: username, password: password);
  }
}
