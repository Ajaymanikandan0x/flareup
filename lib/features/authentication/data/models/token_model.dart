class AuthResponseModel {
  final String token;
  final String refreshToken;

  AuthResponseModel({
    required this.token,
    required this.refreshToken,
  });

  // Factory method to create a model from JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }

  // Method to convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refreshToken,
    };
  }
}
