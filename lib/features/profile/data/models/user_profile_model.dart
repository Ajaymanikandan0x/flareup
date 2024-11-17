import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel {
  final String id;
  final String username;
  final String? profileImage;
  final String fullName;
  final String? phoneNumber;
  final String email;
  final String role;
  final String? gender;

  UserProfileModel({
    required this.fullName,
    this.profileImage,
    this.phoneNumber,
    this.gender,
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
        id: json['id'],
        username: json['username'],
        profileImage: json['profileImage'],
        fullName: json['fullName'],
        email: json['email'],
        role: json['role'],
        gender: json['gender'],
        phoneNumber: json['phoneNumber']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profileImage':profileImage,
      'fullName': fullName,
      'email': email,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      profileImage: profileImage,
      username: username,
      fullName: fullName,
      gender: gender,
      phoneNumber: phoneNumber,
      email: email,
      role: role,
    );
  }
}
