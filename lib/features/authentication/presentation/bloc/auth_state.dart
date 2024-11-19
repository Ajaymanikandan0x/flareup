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

  const OtpVerificationSuccess({required this.email, required this.message});

  @override
  List<Object> get props => [email, message];
}


