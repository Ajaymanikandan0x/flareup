import 'package:flareup/features/authentication/domain/entities/user_entities_signup.dart';

import '../repositories/auth_repo_domain.dart';

class SignupUseCase {
  final AuthRepositoryDomain authRepository;

  SignupUseCase(this.authRepository);

  Future<UserEntitiesSignup> call(
      {required String username,
      required String fullName,
      required String email,
      required String password,
    required  String role}) {
    return authRepository.signup(username: username, fullName: fullName, email: email, password: password, role: role);
  }
}
