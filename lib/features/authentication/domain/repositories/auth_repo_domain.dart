import '../entities/user_entities_signup.dart';
import '../entities/user_model_signin.dart';

abstract class AuthRepositoryDomain {
  Future<UserEntitySignIn> login(String username, String password);
  Future<UserEntitiesSignup> signup(
    String username,
    String fullName,
    String role,
    String email,
    String password,
  );
}
