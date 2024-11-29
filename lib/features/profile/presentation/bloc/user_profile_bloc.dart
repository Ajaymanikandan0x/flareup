import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';
import '../../../../core/storage/secure_storage_service.dart';

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
      print('Starting profile update with data:');
      print('ID: ${event.updatedProfile.id}');
      print('Username: ${event.updatedProfile.username}');
      print('Full Name: ${event.updatedProfile.fullName}');
      print('Email: ${event.updatedProfile.email}');
      print('Phone: ${event.updatedProfile.phoneNumber}');
      print('Profile Image: ${event.updatedProfile.profileImage}');
      
      await updateUserProfile(event.updatedProfile);
      
      // Fetch the updated profile
      final updatedUser = await getUserProfile(event.updatedProfile.id);
      emit(UserProfileLoaded(updatedUser));
    } catch (e) {
      print('Profile update failed: $e');
      emit(UserProfileError('Failed to update user profile: $e'));
    }
  }

  Future<void> _onUploadProfileImage(
      UploadProfileImage event, Emitter<UserProfileState> emit) async {
    print('\n=== UserProfileBloc._onUploadProfileImage ===');
    
    // Store current user data before changing state
    UserProfileEntity? currentUser;
    if (state is UserProfileLoaded) {
      currentUser = (state as UserProfileLoaded).user;
    } else {
      emit(const ProfileImageUploadFailure('Invalid state for profile update'));
      return;
    }
    
    emit(ProfileImageUploading());
    
    try {
      print('Input image file:');
      print('Path: ${event.image.path}');
      print('Exists: ${await event.image.exists()}');
      print('Size: ${await event.image.length()} bytes');

      print('\nStarting image upload...');
      final imageUrl = await uploadProfileImage(event.image);
      print('Received image URL: $imageUrl');

      if (imageUrl != null) {
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

        print('\nUpdating profile with new image...');
        print('New image URL: $imageUrl');
        await updateUserProfile.call(updatedUser, onlyProfileImage: true);
        print('Profile update successful');

        emit(ProfileImageUploadSuccess(imageUrl));
        print('Reloading user profile...');
        add(LoadUserProfile(currentUser.id));
      } else {
        print('\nError: Null image URL received');
        emit(const ProfileImageUploadFailure('Failed to upload image'));
      }
    } catch (e, stackTrace) {
      print('\nError in profile image upload:');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace: $stackTrace');
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
        profileImage: currentUser.profileImage,
        password: currentUser.password,
      );

      emit(UserProfileLoading());
      try {
        print('Updating field: ${event.fieldType} with value: ${event.newValue}');
        await updateUserProfile(updatedUser);
        final refreshedUser = await getUserProfile(updatedUser.id);
        emit(UserProfileLoaded(refreshedUser));
      } catch (e) {
        print('Error updating profile field: $e');
        final errorMessage = e.toString().contains('Exception:') 
            ? e.toString().split('Exception:').last.trim()
            : 'Failed to update ${event.fieldType}';
        emit(UserProfileError(errorMessage));
      }
    }
  }
}
