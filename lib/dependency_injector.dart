import 'features/authentication/data/datasources/remote_data.dart';
import 'features/authentication/data/repositories/auth_repo_data.dart';
import 'features/authentication/domain/repositories/auth_repo_domain.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/usecases/signup_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';

class DependencyInjector {
  static final DependencyInjector _instance = DependencyInjector._internal();

  factory DependencyInjector() {
    return _instance;
  }

  DependencyInjector._internal();

  late UserRemoteDatasource _userRemoteDatasource;
  late AuthRepositoryDomain _authRepository;
  late LoginUseCase _loginUseCase;
  late SignupUseCase _signupUseCase;
  late AuthBloc _authBloc;

  void setup() {
    _userRemoteDatasource = UserRemoteDatasource();
    _authRepository = UserRepositoryImpl(_userRemoteDatasource);
    _loginUseCase = LoginUseCase(_authRepository);
    _signupUseCase = SignupUseCase(_authRepository);
    _authBloc = AuthBloc(loginUseCase: _loginUseCase, signupUseCase: _signupUseCase);
  }

  AuthBloc get authBloc => _authBloc;
}