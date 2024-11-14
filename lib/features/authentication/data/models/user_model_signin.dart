import '../../domain/entities/user_model_signin.dart';

class UserModelSignIn {
  final String username;
  final String password;

  UserModelSignIn({
    required this.username,
    required this.password,
  });

  factory UserModelSignIn.fromJson(Map<String, dynamic> json) {
    return UserModelSignIn(
      username: json['username'],
      password: json['password'],
    );
  }

  // Method to convert UserModel to UserEntity (for domain layer)
  UserEntitySignIn toEntity() {
    return UserEntitySignIn(
      username: username,
      password: password,
    );
  }
}
