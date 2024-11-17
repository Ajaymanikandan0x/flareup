import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class GetUserProfileUseCase {
  final UserProfileRepositoryDomain repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfileEntity> call(String userId) {
    return repository.getUserProfile(userId);
  }
}
