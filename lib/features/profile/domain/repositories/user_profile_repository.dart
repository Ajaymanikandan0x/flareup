import '../entities/user_profile_entity.dart';

abstract class UserProfileRepositoryDomain {
  Future<UserProfileEntity> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfileEntity userProfile);
}
