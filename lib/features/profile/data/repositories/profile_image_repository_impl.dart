import 'dart:io';
import '../../../../core/utils/cloudinary_service.dart';
import '../../domain/repositories/profile_image_repository.dart';

class ProfileImageRepositoryImpl implements ProfileImageRepository {
  final CloudinaryService _cloudinaryService;

  ProfileImageRepositoryImpl(this._cloudinaryService);

  @override
  Future<String?> uploadProfileImage(File image) async {
    try {
      print('\n=== ProfileImageRepositoryImpl.uploadProfileImage ===');
      print('Image file path: ${image.path}');
      print('Image file size: ${await image.length()} bytes');
      
      final result = await _cloudinaryService.uploadFile(image, UploadType.profile);
      
      print('Upload result: $result');
      return result;
    } catch (e, stackTrace) {
      print('\nRepository Error:');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}