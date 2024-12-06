import 'package:flareup/features/authentication/presentation/widgets/otp/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/routs.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/utils/countdown_timer.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String email = args['email'] as String;
    final bool isPasswordReset = args['isPasswordReset'] ?? false;

    // Calculate responsive dimensions
    final iconSize = Responsive.isTablet ? 55.0 : 45.0;
    final titleFontSize = Responsive.isTablet ? 32.0 : 28.0;
    final bodyFontSize = Responsive.isTablet ? 18.0 : 16.0;
    final containerPadding = Responsive.isTablet ? 24.0 : 20.0;

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
          if (state is! AuthLoading) {
            return Scaffold(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppPalette.darkCard
                  : AppPalette.lightCard,
              appBar: AppBar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppPalette.darkCard
                    : AppPalette.lightCard,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppPalette.darkCard
                        : AppPalette.lightCard,
                    size: Responsive.isTablet ? 28.0 : 24.0,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  "OTP Verification",
                  style: AppTextStyles.primaryTextTheme(
                    fontSize: Responsive.titleFontSize,
                  ),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.horizontalPadding,
                      vertical: Responsive.verticalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: Responsive.spacingHeight * 2),
                        Container(
                          padding: EdgeInsets.all(containerPadding),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppPalette.primaryGradient,
                          ),
                          child: Icon(
                            Icons.email_outlined,
                            size: iconSize,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppPalette.darkCard
                                    : AppPalette.lightCard,
                          ),
                        ),
                        SizedBox(height: Responsive.spacingHeight),
                        Text(
                          "OTP Verification",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppPalette.darkCard
                                    : AppPalette.lightCard,
                          ),
                        ),
                        SizedBox(height: Responsive.spacingHeight),
                        Text(
                          "We sent your code to",
                          style: AppTextStyles.hindTextTheme(
                            fontSize: bodyFontSize,
                          ),
                        ),
                        SizedBox(height: Responsive.spacingHeight * 0.5),
                        Text(
                          email,
                          style: AppTextStyles.primaryTextTheme(
                            fontSize: bodyFontSize,
                          ),
                        ),
                        SizedBox(height: Responsive.spacingHeight * 0.5),
                        CountdownTimer(
                          duration: const Duration(seconds: 30),
                          onTimerComplete: () {
                            // Timer completed
                          },
                        ),
                        SizedBox(height: Responsive.spacingHeight * 2),
                        OtpForm(
                          email: email,
                          isPasswordReset: isPasswordReset,
                        ),
                        SizedBox(height: Responsive.spacingHeight),
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
                                  fontSize: bodyFontSize,
                                ),
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
          return Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppPalette.darkCard
                : AppPalette.lightCard,
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
