import 'dart:io';
import '../repositories/profile_image_repository.dart';

class UploadProfileImageUseCase {
  final ProfileImageRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<String?> call(File image) {
    return repository.uploadProfileImage(image);
  }
}