import 'dart:io';

abstract class ProfileImageRepository {
  Future<String?> uploadProfileImage(File image);
}