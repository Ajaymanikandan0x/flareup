import '../../domain/entities/otp_entities.dart';

class OtpModel {
  final String email;
  final String otp;
  final String? message;
  final bool success;

  OtpModel({
    required this.email,
    required this.otp,
    this.message,
    this.success = false,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json, {
    required String email,
    required String otp,
  }) {
    return OtpModel(
      email: email,
      otp: otp,
      message: json['message'] as String?,
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'enteredOtp': otp,
      'message': message,
    };
  }

  OtpEntity toEntity() {
    return OtpEntity(
      message: message ?? '',
      email: email,
      otp: otp,
    );
  }
}
