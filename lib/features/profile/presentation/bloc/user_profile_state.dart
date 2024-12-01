part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileLoading extends UserProfileState {}

final class UserProfileLoaded extends UserProfileState {
  final UserProfileEntity user;

  const UserProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

final class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileImageUploading extends UserProfileState {}

class ProfileImageUploadSuccess extends UserProfileState {
  final String imageUrl;

  const ProfileImageUploadSuccess(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ProfileImageUploadFailure extends UserProfileState {
  final String error;

  const ProfileImageUploadFailure(this.error);

  @override
  List<Object> get props => [error];
}
