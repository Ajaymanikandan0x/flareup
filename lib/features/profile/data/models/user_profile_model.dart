import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel {
  final int id;
  final String username;
  final String? profileImage;
  final String fullName;
  final String? phoneNumber;
  final String email;
  final String role;
  final String? password;

  UserProfileModel({
    required this.id,
    required this.username,
    this.profileImage,
    required this.fullName,
    this.phoneNumber,
    this.password,
    required this.email,
    required this.role,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: int.parse(json['id'].toString()),
      username: json['username'] ?? '',
      profileImage: json['profile_picture'],
      fullName: json['fullname'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phoneNumber: json['phone_number'],
      password: null,
    );
  }

  Map<String, dynamic> toJson({bool onlyProfileImage = false}) {
    Map<String, dynamic> data = {
      'id': id,
      'username': username,
      'fullname': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'update_type': onlyProfileImage ? 'profile_image_only' : 'full_profile',
      'profile_publicId': profileImage
    };

    return data;
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id.toString(),
      profileImage: profileImage,
      username: username,
      fullName: fullName,
      password: password,
      phoneNumber: phoneNumber,
      email: email,
      role: role,
    );
  }
}
