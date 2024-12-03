import 'package:equatable/equatable.dart';

import '../../domain/entities/user_model_signin.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntitySignIn userEntity;
  final String message;

  const AuthSuccess({required this.userEntity, required this.message});

  @override
  List<Object> get props => [userEntity, message];
}

// Add this new state for Google Auth
class GoogleAuthSuccess extends AuthState {
  final UserEntitySignIn userEntity;
  final String message;

  const GoogleAuthSuccess({
    required this.userEntity,
    required this.message,
  });

  @override
  List<Object> get props => [userEntity, message];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// New state for sign-up success
class SignupSuccess extends AuthState {
  final String email;
  final String message;

  const SignupSuccess({required this.email, required this.message});

  @override
  List<Object> get props => [email, message];
}

// Add a new state to track OTP verification
class OtpVerificationState extends AuthState {
  final String email;

  const OtpVerificationState({required this.email});

  @override
  List<Object> get props => [email];
}

// Add this class after OtpVerificationState
class OtpVerificationSuccess extends AuthState {
  final String email;
  final String message;
  final String otp;

  const OtpVerificationSuccess({
    required this.email,
    required this.message,
    required this.otp,
  });

  @override
  List<Object> get props => [email, message, otp];
}

class EmailAuthSuccess extends AuthState {
  final UserEntitySignIn userEntity;
  final String message;

  const EmailAuthSuccess({required this.userEntity, required this.message});
}

class ForgotPasswordSuccess extends AuthState {
  final String email;
  final String message;

  const ForgotPasswordSuccess({required this.email, required this.message});

  @override
  List<Object> get props => [email, message];
}

class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

// Add this new state for password reset OTP verification
class PasswordResetOtpSuccess extends AuthState {
  final String email;
  final String message;
  final String otp;

  const PasswordResetOtpSuccess({
    required this.email,
    required this.message,
    required this.otp,
  });

  @override
  List<Object> get props => [email, message, otp];
}

// Add this class after PasswordResetOtpSuccess
class ResetPasswordInitial extends AuthState {
  final String email;
  final String otp;

  const ResetPasswordInitial({
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}


