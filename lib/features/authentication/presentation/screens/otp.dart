import 'package:flareup/features/authentication/presentation/widgets/otp/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routs.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
        
        if (state is OtpVerificationSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context, 
              AppRouts.signIn, 
              (route) => false
            );
          });
        }
        
        if (state is SignupSuccess || state is OtpVerificationState) {
          final email = state is SignupSuccess
              ? state.email
              : (state as OtpVerificationState).email;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text("OTP Verification"),
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "OTP Verification",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "We sent your code to $email\nThis code will expire in 00:30",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const OtpForm(),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              ResendOtpEvent(email: email),
                            );
                      },
                      child: const Text("Resend OTP Code"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is! SignupSuccess && 
            state is! OtpVerificationState && 
            state is! OtpVerificationSuccess) {
          return _buildErrorScreen(context);
        }
        
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text("Something went wrong"),
      ),
    );
  }
}
