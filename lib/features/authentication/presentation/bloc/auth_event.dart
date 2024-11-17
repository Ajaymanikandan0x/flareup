import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class SignupEvent extends AuthEvent {
  final String username;
  final String fullName;
  final String role;
  final String email;
  final String password;

  const SignupEvent({
    required this.username,
    required this.role,
    required this.email,
    required this.fullName,
    required this.password,
  });

  @override
  List<Object?> get props => [username, fullName, role, email, password];
}
