class UserProfileEntity {
  final String id;
  final String username;
  final String fullName;
  final String? phoneNumber;
  final String email;
  final String role;
  final String? profileImage;
  final String? password;

  UserProfileEntity(
      {required this.fullName,
      this.profileImage,
      this.phoneNumber,
      required this.id,
      required this.username,
      required this.email,
      required this.role,
      required this.password});
}
