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

class SignupSuccessEvent extends AuthEvent {
  final String email;
  
  const SignupSuccessEvent({required this.email});
  
  @override
  List<Object?> get props => [email];
}

class SendOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const SendOtpEvent({required this.email,required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class ResendOtpEvent extends AuthEvent {
  final String email;

  const ResendOtpEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
