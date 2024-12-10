import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepositoryDomain {
  final UserProfileRemoteDataSourceImpl remoteDatasource;

  UserProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserProfileEntity> getUserProfile(String userId) async {
    final model = await remoteDatasource.fetchUserProfile(userId);
    return model.toEntity();
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity userProfile, {bool onlyProfileImage = false}) async {
    final model = UserProfileModel(
      id: int.parse(userProfile.id),
      profileImage: userProfile.profileImage,
      username: userProfile.username,
      email: userProfile.email,
      role: userProfile.role,
      fullName: userProfile.fullName,
      phoneNumber: userProfile.phoneNumber,
    );
    await remoteDatasource.updateUserProfile(model, onlyProfileImage: onlyProfileImage);
  }
}
