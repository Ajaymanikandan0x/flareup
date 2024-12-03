class ApiEndpoints {
  static const baseUrl = 'http://10.0.2.2:8081/';
  static const signUp =
      'register/'; //(post) username, fullname, email, phone_number, role, password
  static const otpVerification = 'otp_verification/'; //(post) email, enteredOtp
  static const login = 'login/'; // (post)username, password
  static const resendOtp = 'resend_otp/'; //(post) email
  static const user = 'user/user_id/'; //(get) all user id
  static const refreshToken = 'token_refresh/'; //(post) refresh_token
  static const logout = 'logout/'; //(post)  just send a request
  static const updateUserProfile =
      'user/user_id/update_user_profile/'; //(patch) username, fullname, phone_number, email, profile_publicId  update user profile
  static const googleAuth =
      'GoogleAuth/'; //(post) registration gToken,role  login gToken
  static const updatePassword =
      'user/user_id/set_password/'; //{’new_password’: ‘’, ‘confirm_password’: ‘'
  static const forgotPassword = 'forgot-password/'; //(post) email
  static const verifyOtpForgotPassword =
      'verify-otp-forgot-password/'; //(post) email, enteredOtp
  static const setNewPassword =
      'set-new-password/'; //(post) new_password, confirm_password, email

}
