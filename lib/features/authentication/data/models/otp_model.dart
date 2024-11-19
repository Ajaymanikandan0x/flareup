import '../../domain/entities/otp_entities.dart';

class OtpModel {
  final String email;
  final String otp;

  OtpModel({required this.email, required this.otp});

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      email: json['email'] ?? '',
      otp: json['enteredOtp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'enteredOtp': otp,
    };
  }

  OtpEntity toEntity() {
    return OtpEntity(
      email: email,
      otp: otp,
    );
  }
}
