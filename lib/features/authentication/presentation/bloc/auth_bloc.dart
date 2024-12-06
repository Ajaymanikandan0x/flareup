import 'package:flareup/features/authentication/domain/usecases/otp_send_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_error.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/auth_repo_domain.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/verify_reset_password_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final SendOtpUseCase otpUsecase;
  final ResendOtpUseCase resendOtpUseCase;
  final LogoutUseCase logoutUseCase;
  final SecureStorageService storageService;
  final AuthRepositoryDomain authRepository;

  final VerifyResetPasswordOtpUseCase verifyResetPasswordOtpUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.otpUsecase,
    required this.resendOtpUseCase,
    required this.logoutUseCase,
    required this.storageService,
    required this.authRepository,
    required this.verifyResetPasswordOtpUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignupEvent>(_onSignupEvent);
    on<SendOtpEvent>(_otpSend);
    on<ResendOtpEvent>(_resendOtp);
    on<LogoutEvent>(_onLogoutEvent);
    on<GoogleAuthEvent>(_onGoogleAuthEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<VerifyResetPasswordOtpEvent>(_onVerifyResetPasswordOtp);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userEntity = await loginUseCase.call(
        username: event.username,
        password: event.password,
      );

      await storageService.saveTokens(
        accessToken: userEntity.accessToken,
        refreshToken: userEntity.refreshToken,
        userId: userEntity.id.toString(),
      );

      emit(AuthSuccess(userEntity: userEntity, message: 'Login successful!'));
    } catch (e) {
      emit(AuthFailure(error: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignupEvent(
      SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      Logger.debug('Starting signup process for ${event.username}');

      await signupUseCase.call(
          username: event.username,
          fullName: event.fullName,
          email: event.email,
          password: event.password,
          role: event.role);

      Logger.debug('Signup successful');
      emit(SignupSuccess(
          email: event.email, message: 'Account created successfully!'));
    } on AppError catch (e) {
      Logger.error('Signup failed with AppError', e);
      emit(AuthFailure(error: e.userMessage));
    } catch (e) {
      Logger.error('Signup failed with unexpected error', e);
      emit(AuthFailure(error: 'Failed to create account. Please try again.'));
    }
  }

  Future<void> _otpSend(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      Logger.debug('Starting OTP verification for ${event.email}');
      final result = await otpUsecase.call(
        email: event.email,
        otp: event.otp,
      );

      Logger.debug('OTP verification completed successfully');
      emit(OtpVerificationSuccess(
        email: event.email,
        message: result.message,
        otp: event.otp,
      ));
    } on AppError catch (e) {
      Logger.error('OTP verification failed with AppError', e);
      emit(AuthFailure(error: e.userMessage));
    } catch (e) {
      Logger.error('Unexpected error during OTP verification', e);
      emit(AuthFailure(
        error: 'Invalid OTP code. Please try again.',
      ));
    }
  }

  Future<void> _resendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resendOtpUseCase.call(email: event.email);
      emit(OtpResendSuccess(
        email: event.email,
        message: 'OTP has been resent to your email',
      ));
    } on AppError catch (e) {
      emit(AuthFailure(error: e.userMessage));
    } catch (e) {
      emit(AuthFailure(error: 'Failed to resend OTP. Please try again.'));
    }
  }

  Future<void> _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUseCase.call();
      await storageService.clearAll();
      emit(AuthInitial());
    } catch (e) {
      await storageService.clearAll();
      emit(AuthInitial());
    }
  }

  Future<void> _onGoogleAuthEvent(
    GoogleAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      Logger.debug('Attempting Google Sign In...');
      try {
        final userEntity = await authRepository.googleSignIn(
          accessToken: event.accessToken,
        );
        Logger.debug('Google Sign In successful');
        await storageService.saveTokens(
          accessToken: userEntity.accessToken,
          refreshToken: userEntity.refreshToken,
          userId: userEntity.id.toString(),
        );
        emit(AuthSuccess(
            userEntity: userEntity, message: 'Google login successful!'));
      } catch (signInError) {
        Logger.error('Sign In Error:', signInError);
        if (signInError.toString().contains('REGISTRATION_REQUIRED')) {
          Logger.debug('Registration required, attempting signup...');
          final userEntity = await authRepository.googleSignUp(
            accessToken: event.accessToken,
            role: 'user',
          );
          Logger.debug('Registration successful');
          await storageService.saveTokens(
            accessToken: userEntity.accessToken,
            refreshToken: userEntity.refreshToken,
            userId: userEntity.id.toString(),
          );
          emit(AuthSuccess(
              userEntity: userEntity,
              message: 'Google registration successful!'));
        } else {
          final errorMessage = signInError
              .toString()
              .replaceAll('Exception: ', '')
              .replaceAll('Google sign in failed: ', '');
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      Logger.error('Google Auth Error:', e);
      final errorMessage = e
          .toString()
          .replaceAll('Exception: ', '')
          .replaceAll('Google Oauth Failed: ', '');
      emit(AuthFailure(error: errorMessage));
    }
  }

  Future<void> _onForgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      print('\n=== Forgot Password Request ===');
      print('Attempting to send reset password email to: ${event.email}');

      await authRepository.forgotPassword(email: event.email);

      emit(ForgotPasswordSuccess(
        email: event.email,
        message: 'An OTP has been sent to your email',
      ));
    } catch (e) {
      print('\nError in forgot password: $e');
      String errorMessage = e.toString().replaceAll('Exception:', '').trim();
      emit(AuthFailure(error: errorMessage));
    }
  }

  Future<void> _onResetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.resetPassword(
        email: event.email,
        newPassword: event.newPassword,
        otp: event.otp,
      );
      emit(const ResetPasswordSuccess(
        message:
            'Password reset successful! Please login with your new password.',
      ));
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception:', '').trim();
      emit(AuthFailure(error: errorMessage));
    }
  }

  Future<void> _onVerifyResetPasswordOtp(
    VerifyResetPasswordOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      Logger.debug('Processing Verify Reset Password OTP');
      Logger.debug('Email: ${event.email}');

      await verifyResetPasswordOtpUseCase.call(
        email: event.email,
        otp: event.otp,
      );

      Logger.debug('Reset password OTP verification successful');
      emit(PasswordResetOtpSuccess(
        email: event.email,
        message: 'OTP verified successfully',
        otp: event.otp,
      ));
    } catch (e) {
      Logger.error('Error in verify reset password OTP', e);
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception:', '').trim();
      }
      emit(AuthFailure(error: errorMessage));
    }
  }
}
