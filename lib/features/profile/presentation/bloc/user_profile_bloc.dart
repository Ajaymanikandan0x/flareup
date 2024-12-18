import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getUserProfile;
  final UpdateUserProfileUseCase updateUserProfile;
  final UploadProfileImageUseCase uploadProfileImage;
  final SecureStorageService storageService;

  UserProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.uploadProfileImage,
    required this.storageService,
  }) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<UpdateProfileField>(_onUpdateProfileField);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final storedUserId = await storageService.getUserId();
      
      if (storedUserId == null) {
        emit(const UserProfileError('No stored user ID found'));
        return;
      }

      if (storedUserId != event.userId) {
        emit(const UserProfileError('User ID mismatch'));
        return;
      }

      final user = await getUserProfile(event.userId);
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserProfileError('Failed to load user profile: $e'));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      await updateUserProfile(event.updatedProfile, onlyProfileImage: event.onlyProfileImage);
      
      // Wait for the update to be processed
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedUser = await getUserProfile(event.updatedProfile.id);
      emit(UserProfileLoaded(updatedUser));
    } catch (e) {
      Logger.error('Profile update failed:', e);
      emit(UserProfileError('Failed to update user profile: $e'));
    }
  }

  Future<void> _onUploadProfileImage(
      UploadProfileImage event, Emitter<UserProfileState> emit) async {
    if (state is! UserProfileLoaded) {
      emit(const ProfileImageUploadFailure('Invalid state for profile update'));
      return;
    }

    final currentUser = (state as UserProfileLoaded).user;
    emit(ProfileImageUploading());

    try {
      final imageUrl = await uploadProfileImage(event.image);
      
      if (imageUrl == null) {
        emit(const ProfileImageUploadFailure('Failed to upload image'));
        return;
      }

      final updatedUser = UserProfileEntity(
        id: currentUser.id,
        username: currentUser.username,
        fullName: currentUser.fullName,
        email: currentUser.email,
        role: currentUser.role,
        profileImage: imageUrl,
        phoneNumber: currentUser.phoneNumber,
        password: currentUser.password,
      );

      await updateUserProfile(updatedUser, onlyProfileImage: true);
      
      // Fetch updated profile
      final refreshedUser = await getUserProfile(currentUser.id);
      emit(UserProfileLoaded(refreshedUser));
      
    } catch (e) {
      Logger.error('Error in profile image upload:', e);
      emit(ProfileImageUploadFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfileField(
    UpdateProfileField event,
    Emitter<UserProfileState> emit,
  ) async {
    if (state is UserProfileLoaded) {
      final currentUser = (state as UserProfileLoaded).user;
      
      final updatedUser = UserProfileEntity(
        id: currentUser.id,
        username: event.fieldType == 'UserName' ? event.newValue : currentUser.username,
        fullName: event.fieldType == 'FullName' ? event.newValue : currentUser.fullName,
        email: event.fieldType == 'Email' ? event.newValue : currentUser.email,
        phoneNumber: event.fieldType == 'PhoneNumber' ? event.newValue : currentUser.phoneNumber,
        role: currentUser.role,
        profileImage: null,
        password: currentUser.password,
      );

      emit(UserProfileLoading());
      try {
        Logger.debug('Updating field: ${event.fieldType} with value: ${event.newValue}');
        await updateUserProfile(updatedUser, onlyProfileImage: false);
        
        // Add a small delay before fetching updated profile
        await Future.delayed(const Duration(milliseconds: 500));
        
        final refreshedUser = await getUserProfile(updatedUser.id);
        emit(UserProfileLoaded(refreshedUser));
      } catch (e) {
        Logger.error('Error updating profile field:', e);
        final errorMessage = e.toString().contains('Exception:') 
            ? e.toString().split('Exception:').last.trim()
            : 'Failed to update ${event.fieldType}';
        emit(UserProfileError(errorMessage));
      }
    }
  }
}
