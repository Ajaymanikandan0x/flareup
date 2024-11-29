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
      password: null,
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson({bool onlyProfileImage = false}) {
    if (onlyProfileImage) {
      return {
        'profile_picture': profileImage,
        'update_type': 'profile_image_only'
      };
    }
    return {
      'username': username,
      'fullname': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'update_type': 'full_profile'
    };
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
