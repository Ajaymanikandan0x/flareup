import 'package:dio/dio.dart';

import 'core/error/error_handler_service.dart';
import 'core/network/dio_interceptor.dart';
import 'core/network/network_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/utils/cloudinary_service.dart';

import 'features/authentication/data/datasources/remote_data.dart';
import 'features/authentication/data/repositories/auth_repo_data.dart';
import 'features/authentication/domain/repositories/auth_repo_domain.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/usecases/logout_usecase.dart';
import 'features/authentication/domain/usecases/otp_send_usecase.dart';
import 'features/authentication/domain/usecases/resend_otp_usecase.dart';
import 'features/authentication/domain/usecases/signup_usecase.dart';
import 'features/authentication/domain/usecases/verify_reset_password_otp_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/profile/data/datasources/user_profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_image_repository_impl.dart';
import 'features/profile/data/repositories/user_profile_repository_impl.dart';
import 'features/profile/domain/repositories/user_profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'features/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'features/profile/presentation/bloc/user_profile_bloc.dart';

class DependencyInjector {
  static final DependencyInjector _instance = DependencyInjector._internal();

  factory DependencyInjector() {
    return _instance;
  }

  DependencyInjector._internal();

  // Authentication dependencies
  late AuthRepositoryDomain _authRepository;
  late LoginUseCase _loginUseCase;
  late SendOtpUseCase _otpUseCase;
  late SignupUseCase _signupUseCase;
  late LogoutUseCase _logoutUseCase;
  late ResendOtpUseCase _resendOtpUseCase;
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
    final storageService = SecureStorageService();
    final dio = Dio()..interceptors.add(AuthInterceptor(storageService, Dio()));
    final networkService = NetworkService(dio);
    final remoteDatasource = UserRemoteDatasource(networkService);
    final errorHandlerService = AppErrorHandlerService();

    _authRepository = UserRepositoryImpl(remoteDatasource);
    _loginUseCase = LoginUseCase(_authRepository);
    _otpUseCase = SendOtpUseCase(_authRepository);
    _signupUseCase = SignupUseCase(_authRepository);
    _logoutUseCase = LogoutUseCase(_authRepository);
    _resendOtpUseCase = ResendOtpUseCase(_authRepository);

    final verifyResetPasswordOtpUseCase =
        VerifyResetPasswordOtpUseCase(_authRepository);

    _authBloc = AuthBloc(
      otpUsecase: _otpUseCase,
      loginUseCase: _loginUseCase,
      signupUseCase: _signupUseCase,
      resendOtpUseCase: _resendOtpUseCase,
      logoutUseCase: _logoutUseCase,
      authRepository: _authRepository,
      verifyResetPasswordOtpUseCase: verifyResetPasswordOtpUseCase,
      storageService: storageService,
      errorHandler: errorHandlerService,
    );
  }

  void _setupUserProfileDependencies() {
    final storageService = SecureStorageService();
    final dio = Dio()..interceptors.add(AuthInterceptor(storageService, Dio()));

    final cloudinaryService = CloudinaryService(storageService);
    final profileImageRepository =
        ProfileImageRepositoryImpl(cloudinaryService);
    final uploadProfileImageUseCase =
        UploadProfileImageUseCase(profileImageRepository);

    _userProfileRemoteDatasource = UserProfileRemoteDataSourceImpl(
      storageService: storageService,
      dio: dio,
    );

    _userProfileRepository =
        UserProfileRepositoryImpl(_userProfileRemoteDatasource);
    _getUserProfileUseCase = GetUserProfileUseCase(_userProfileRepository);
    _updateUserProfileUseCase =
        UpdateUserProfileUseCase(_userProfileRepository);

    _userProfileBloc = UserProfileBloc(
      getUserProfile: _getUserProfileUseCase,
      updateUserProfile: _updateUserProfileUseCase,
      uploadProfileImage: uploadProfileImageUseCase,
      storageService: storageService,
    );
  }

  // Getters
  AuthBloc get authBloc => _authBloc;
  UserProfileBloc get userProfileBloc => _userProfileBloc;
}
