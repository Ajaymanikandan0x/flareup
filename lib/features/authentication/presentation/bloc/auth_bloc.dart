import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthBloc({required this.loginUseCase, required this.signupUseCase})
      : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignupEvent>(_onSignupEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userEntity =
          await loginUseCase.call(event.username, event.password);
      emit(AuthSuccess(message: 'Login successful!'));
    } catch (e) {
      emit(AuthFailure(error: 'Login failed!'));
    }
  }

  Future<void> _onSignupEvent(
      SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userEntity = await signupUseCase.call(event.username, event.email,
          event.password, event.role, event.fullName);
      emit(AuthSuccess(message: 'Signup successful!'));
    } catch (e) {
      emit(AuthFailure(error: 'Signup failed!'));
    }
  }
}
