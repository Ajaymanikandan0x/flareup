import 'package:flareup/features/authentication/domain/entities/user_entities_signup.dart';

import '../repositories/auth_repo_domain.dart';

class SignupUseCase {
  final AuthRepositoryDomain authRepository;

  SignupUseCase(this.authRepository);

  Future<UserEntitiesSignup> call(String username, String fullName,
      String email, String password, String role) {
    return authRepository.signup(username, fullName, role, email, password);
  }
}
