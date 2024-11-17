import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class UpdateUserProfileUseCase {
  final UserProfileRepositoryDomain repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> call(UserProfileEntity userProfile) {
    return repository.updateUserProfile(userProfile);
  }
}