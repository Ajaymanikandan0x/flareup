class UserEntitySignIn {
  final int id;
  final String username;
  final String email;
  final String role;
  final String accessToken;
  final String refreshToken;

  UserEntitySignIn({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });
}
