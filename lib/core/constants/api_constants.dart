class ApiEndpoints {
  static const baseUrl = 'http://10.0.2.2:8081/';
  static const signUp =
      'register/'; // username, fullname, email, phone_number, role, password
  static const otpVerification = 'otp_verification/'; // email, enteredOtp
  static const login = 'login/'; // username, password
  static const resendOtp = 'resend_otp/'; // email
  static const user = 'user/';
}
