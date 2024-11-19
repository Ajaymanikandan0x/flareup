import 'package:flareup/features/authentication/domain/usecases/otp_send_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final SendOtpUseCase otpUsecase;

  AuthBloc(
      {required this.loginUseCase,
      required this.signupUseCase,
      required this.otpUsecase})
      : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignupEvent>(_onSignupEvent);
    on<SendOtpEvent>(_otpSend);
    on<ResendOtpEvent>(_resendOtp);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userEntity = await loginUseCase.call(
          username: event.username, password: event.password);
      emit(AuthSuccess(userEntity: userEntity, message: 'Login successful!'));
    } catch (e) {
      emit(AuthFailure(error: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignupEvent(
      SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await signupUseCase.call(
          username: event.username,
          fullName: event.fullName,
          email: event.email,
          password: event.password,
          role: event.role);
      emit(SignupSuccess(email: event.email, message: 'Otp send successful!'));
    } catch (e) {
      emit(AuthFailure(error: 'Signup failed: ${e.toString()}'));
    }
  }

  Future<void> _otpSend(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await otpUsecase.call(email: event.email, otp: event.otp);
      emit(OtpVerificationSuccess(
        email: event.email,
        message: 'OTP verification successful!'
      ));
    } catch (e) {
      emit(AuthFailure(error: 'OTP verification failed: ${e.toString()}'));
    }
  }

  Future<void> _resendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await otpUsecase.call(email: event.email, otp: '');
      emit(OtpVerificationState(email: event.email));
    } catch (e) {
      emit(AuthFailure(error: 'Failed to resend OTP: ${e.toString()}'));
    }
  }
}
