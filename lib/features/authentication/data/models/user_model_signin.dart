import '../../domain/entities/user_model_signin.dart';

class UserModelSignIn {
  final int id;
  final String accessToken;
  final String refreshToken;
  final String username;
  final String email;
  final String role;

  UserModelSignIn({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UserModelSignIn.fromJson(Map<String, dynamic> json) {
    return UserModelSignIn(
      id: json['id'],
      accessToken:json['accessToken'],
      refreshToken:json['refreshToken'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }

  UserEntitySignIn toEntity() {
    return UserEntitySignIn(
      id: id,
      accessToken:'accessToken',
      refreshToken:'refreshToken',
      username: username,
      email: email,
      role: role,
    );
  }
}
