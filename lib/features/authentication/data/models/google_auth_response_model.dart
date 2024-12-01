// lib/features/authentication/data/models/google_auth_response_model.dart

class GoogleAuthResponseModel {
  final String gToken;

  GoogleAuthResponseModel({required this.gToken});

  factory GoogleAuthResponseModel.fromJson(Map<String, dynamic> json) {
    return GoogleAuthResponseModel(
      gToken: json['gToken'] ?? '',
    );
  }
}