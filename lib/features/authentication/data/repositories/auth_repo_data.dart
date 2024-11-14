import '../../domain/entities/user_entities_signup.dart';
import '../../domain/entities/user_model_signin.dart';
import '../../domain/repositories/auth_repo_domain.dart';
import '../datasources/remote_data.dart';

class UserRepositoryImpl implements AuthRepositoryDomain {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserEntitySignIn> login(String username, String password) async {
    try {
      final userModel =
          await remoteDatasource.login(username: username, password: password);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserEntitiesSignup> signup(String username, String fullName,
      String role, String email, String password) async {
    try {
      final userModel = await remoteDatasource.signUp(
          fullName: fullName,
          email: email,
          role: role,
          username: username,
          password: password);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }
}
