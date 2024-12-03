import 'package:flareup/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import 'otp_box.dart';

class OtpForm extends StatelessWidget {
  final String email;

  final bool isPasswordReset;

  
  const OtpForm({
    super.key,
    required this.email,

  });

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers =
        List.generate(6, (index) => TextEditingController());

    void clearOtpFields() {
      for (var controller in controllers) {
        controller.clear();
      }
    }

    void verifyOtp() {
      String otp = controllers.map((controller) => controller.text).join();
      

      if (otp.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid 6-digit OTP'),
            backgroundColor: AppPalette.error,
          ),
        );
        return;
      }

      if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP should only contain numbers'),
            backgroundColor: AppPalette.error,
          ),
        );
        return;
      }


      print('Verifying OTP: $otp for email: $email');
      print('Is Password Reset: $isPasswordReset');

      if (isPasswordReset) {
        context.read<AuthBloc>().add(
          VerifyResetPasswordOtpEvent(
            email: email,
            otp: otp,
          ),
        );
      } else {
        context.read<AuthBloc>().add(
          SendOtpEvent(email: email, otp: otp),
        );
      }

    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          String message = state.error;

          if (message.contains('Exception:')) {
            message = message.replaceAll('Exception:', '').trim();
          }

          if (message.contains('Invalid OTP') || 
              message.contains('Please try again')) {
            clearOtpFields();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppPalette.error,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Form(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return OtpBox(controller: controllers[index]);
              }),
            ),
            const SizedBox(height: 100),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final bool isLoading = state is AuthLoading;
                return PrimaryButton(
                  width: 250,
                  height: 60,
                  onTap: isLoading ? () {} : verifyOtp,
                  text: isLoading ? 'Verifying...' : 'Verify',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
