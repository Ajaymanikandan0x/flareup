class OTPResponse {
  final String message;

  OTPResponse({required this.message});

  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
