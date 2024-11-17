import 'package:flareup/features/authentication/domain/entities/user_entities_signup.dart';

class UserModelSignup {
  final String role;
  final String fullName;
  final String userName;
  final String email;
  final String password;
  UserModelSignup(
      {required this.userName,
      required this.role,
      required this.fullName,
      required this.email,
      required this.password});

  factory UserModelSignup.fromJson(Map<String, dynamic> json) {
    return UserModelSignup(
        userName: json['userName'],
        fullName: json['fullName'],
        role: json['role'],
        email: json['email'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'role': role,
      'email': email,
      'password': password
    };
  }

  UserEntitiesSignup toEntity() {
    return UserEntitiesSignup(
      username: userName,
      fullName: fullName,
      password: password,
      role: role,
      email: email,
    );
  }
}