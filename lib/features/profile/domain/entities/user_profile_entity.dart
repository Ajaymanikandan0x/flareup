class UserProfileEntity {
  final String id;
  final String username;
  final String fullName;
  final String? phoneNumber;
  final String email;
  final String role;
  final String? gender;
  final String? profileImage;

  UserProfileEntity({
    required this.fullName,
    this.profileImage,
    this.phoneNumber,
    this.gender,
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });
}
