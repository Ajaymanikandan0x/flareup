import 'package:flareup/features/authentication/domain/usecases/otp_send_usecase.dart';

import 'features/authentication/data/datasources/remote_data.dart';
import 'features/authentication/data/repositories/auth_repo_data.dart';
import 'features/authentication/domain/repositories/auth_repo_domain.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/usecases/signup_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/profile/data/datasources/user_profile_remote_datasource.dart';
import 'features/profile/data/repositories/user_profile_repository_impl.dart';
import 'features/profile/domain/repositories/user_profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'features/profile/presentation/bloc/user_profile_bloc.dart';

class DependencyInjector {
  static final DependencyInjector _instance = DependencyInjector._internal();

  factory DependencyInjector() {
    return _instance;
  }

  DependencyInjector._internal();

  // Authentication dependencies
  late UserRemoteDatasource _userRemoteDatasource;
  late AuthRepositoryDomain _authRepository;
  late LoginUseCase _loginUseCase;
  late SendOtpUseCase _otpUseCase;
  late SignupUseCase _signupUseCase;
  late AuthBloc _authBloc;

  // User profile dependencies
  late UserProfileRemoteDataSourceImpl _userProfileRemoteDatasource;
  late UserProfileRepositoryDomain _userProfileRepository;
  late GetUserProfileUseCase _getUserProfileUseCase;
  late UpdateUserProfileUseCase _updateUserProfileUseCase;
  late UserProfileBloc _userProfileBloc;

  void setup() {
    _setupAuthenticationDependencies();
    _setupUserProfileDependencies();
  }

  void _setupAuthenticationDependencies() {
    _userRemoteDatasource = UserRemoteDatasource();
    _authRepository = UserRepositoryImpl(_userRemoteDatasource);
    _loginUseCase = LoginUseCase(_authRepository);
    _otpUseCase = SendOtpUseCase(_authRepository);
    _signupUseCase = SignupUseCase(_authRepository);
    _authBloc = AuthBloc(
      otpUsecase: _otpUseCase,
      loginUseCase: _loginUseCase,
      signupUseCase: _signupUseCase,
    );
  }

  void _setupUserProfileDependencies() {
    _userProfileRemoteDatasource = UserProfileRemoteDataSourceImpl();
    _userProfileRepository =
        UserProfileRepositoryImpl(_userProfileRemoteDatasource);
    _getUserProfileUseCase = GetUserProfileUseCase(_userProfileRepository);
    _updateUserProfileUseCase =
        UpdateUserProfileUseCase(_userProfileRepository);
    _userProfileBloc = UserProfileBloc(
      getUserProfile: _getUserProfileUseCase,
      updateUserProfile: _updateUserProfileUseCase,
    );
  }

  // Getters
  AuthBloc get authBloc => _authBloc;
  UserProfileBloc get userProfileBloc => _userProfileBloc;
}
