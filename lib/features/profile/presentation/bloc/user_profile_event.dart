part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();
  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  final String userId;

  const LoadUserProfile(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateUserProfile extends UserProfileEvent {
  final UserProfileEntity updatedProfile;

  const UpdateUserProfile(this.updatedProfile);

  @override
  List<Object> get props => [updatedProfile];
}

class UpdateProfileField extends UserProfileEvent {
  final String fieldType;
  final String newValue;

  const UpdateProfileField({
    required this.fieldType,
    required this.newValue,
  });

  @override
  List<Object> get props => [fieldType, newValue];
}

class UploadProfileImage extends UserProfileEvent {
  final File image;

  const UploadProfileImage(this.image);

  @override
  List<Object> get props => [image];
}
