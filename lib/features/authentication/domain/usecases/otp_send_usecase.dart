import 'package:flareup/features/authentication/domain/entities/otp_entities.dart';

import '../repositories/auth_repo_domain.dart';

class SendOtpUseCase {
  final AuthRepositoryDomain repository;

  SendOtpUseCase(this.repository);

  Future<OtpEntity> call({required String email, required String otp}) {
    return repository.sendOtp(email: email, otp: otp);
  }
}
