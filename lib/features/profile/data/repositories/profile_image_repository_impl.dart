import 'dart:io';
import '../../../../core/utils/cloudinary_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/profile_image_repository.dart';


class ProfileImageRepositoryImpl implements ProfileImageRepository {
  final CloudinaryService _cloudinaryService;

  ProfileImageRepositoryImpl(this._cloudinaryService);

  @override
  Future<String?> uploadProfileImage(File image) async {
    try {
      
      Logger.debug('Image file size: ${await image.length()} bytes');
      
      final result = await _cloudinaryService.uploadFile(image, UploadType.profile);
      
      Logger.debug('Upload result: $result');
      return result;
    } catch (e) {
      Logger.debug('Error type: ${e.runtimeType}');
      Logger.debug('Error message: $e');
      rethrow;
    }
  }
}