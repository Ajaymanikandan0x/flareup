import 'package:flareup/features/authentication/presentation/widgets/otp/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/routs.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/utils/countdown_timer.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String email = args['email'] as String;
    final bool isPasswordReset = args['isPasswordReset'] ?? false;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.replaceAll('Exception:', '').trim()),
              backgroundColor: AppPalette.error,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is PasswordResetOtpSuccess) {
          Navigator.pushNamed(
            context,
            AppRouts.resetPassword,
            arguments: {
              'email': state.email,
              'otp': state.otp,
            },
          );
        } else if (state is OtpVerificationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouts.signIn,
            (route) => false,
          );
        } else if (state is OtpResendSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP has been resent successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Show OTP screen for all states except loading
          if (state is! AuthLoading) {
            return Scaffold(
              backgroundColor: AppPalette.backGroundColor,
              appBar: AppBar(
                backgroundColor: AppPalette.backGroundColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppPalette.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  "OTP Verification",
                  style: AppTextStyles.primaryTextTheme(fontSize: 20),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppPalette.myGradient,
                          ),
                          child: const Icon(
                            Icons.email_outlined,
                            size: 45,
                            color: AppPalette.white,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          "OTP Verification",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "We sent your code to",
                          style: AppTextStyles.hindTextTheme(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email,
                          style: AppTextStyles.primaryTextTheme(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        CountdownTimer(
                          duration: const Duration(seconds: 30),
                          onTimerComplete: () {
                            // Timer completed
                          },
                        ),
                        const SizedBox(height: 40),
                        OtpForm(
                          email: email,
                          isPasswordReset: isPasswordReset,
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final bool isLoading = state is AuthLoading;

                            final bool isSessionExpired =
                                state is AuthFailure &&
                                    state.error.contains('Session expired');

                            return TextButton(
                              onPressed: (isLoading || isSessionExpired)
                                  ? null
                                  : () {
                                      context.read<AuthBloc>().add(
                                            ResendOtpEvent(email: email),
                                          );
                                    },
                              style: TextButton.styleFrom(
                                foregroundColor: AppPalette.gradient2,
                              ),
                              child: Text(
                                isLoading
                                    ? "Sending..."
                                    : isSessionExpired
                                        ? "Session Expired"
                                        : "Resend OTP Code",
                                style: AppTextStyles.primaryTextTheme(
                                    fontSize: 16),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          // Show loading indicator
          return const Scaffold(
            backgroundColor: AppPalette.backGroundColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppPalette.gradient2),
              ),
            ),
          );
        },
      ),
    );
  }
}
