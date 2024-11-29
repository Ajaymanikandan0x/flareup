import 'dart:async';

import 'package:flareup/features/authentication/presentation/widgets/otp/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/routs.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          final error = state.error;
          String displayMessage = error;
          
          // Convert error messages to user-friendly format
          if (error.contains('Invalid OTP')) {
            displayMessage = 'Invalid OTP. Please try again.';
          } else if (error.contains('Session expired')) {
            displayMessage = 'Session expired. Please restart the signup process.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(displayMessage),
              backgroundColor: AppPalette.error,
              duration: const Duration(seconds: 2),
            ),
          );

          // Only navigate back for session expiration
          if (error.contains('Session expired')) {
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          }
        }
        
        if (state is OtpVerificationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRouts.signIn, 
            (route) => false
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Show OTP screen for all states except loading
          if (state is! AuthLoading) {
            final email = state is SignupSuccess 
                ? state.email 
                : state is OtpVerificationState 
                    ? state.email 
                    : '';
            
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        OtpForm(email: email),
                        const SizedBox(height: 32),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final bool isLoading = state is AuthLoading;
                            final bool isSessionExpired = state is AuthFailure && 
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
                                style: AppTextStyles.primaryTextTheme(fontSize: 16),
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

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final Function() onTimerComplete;

  const CountdownTimer({
    super.key,
    required this.duration,
    required this.onTimerComplete,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        } else {
          _timer.cancel();
          widget.onTimerComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    
    return Text(
      "This code will expire in $minutes:$seconds",
      style: AppTextStyles.hindTextTheme(fontSize: 16),
    );
  }
}
