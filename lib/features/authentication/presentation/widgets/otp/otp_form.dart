import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import 'otp_box.dart';

class OtpForm extends StatefulWidget {
  final String email;
  final bool isPasswordReset;

  const OtpForm({
    super.key,
    required this.email,
    this.isPasswordReset = false,
  });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  // Move controllers to state
  late final List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void clearOtpFields() {
    for (var controller in controllers) {
      controller.clear();
    }
  }

  void verifyOtp() {
    String otp = controllers.map((controller) => controller.text.trim()).join();

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

    FocusScope.of(context).unfocus();

    if (widget.isPasswordReset) {
      context.read<AuthBloc>().add(
            VerifyResetPasswordOtpEvent(
              email: widget.email,
              otp: otp,
            ),
          );
    } else {
      context.read<AuthBloc>().add(
            SendOtpEvent(email: widget.email, otp: otp),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure &&
            (state.error.contains('Invalid OTP') ||
                state.error.contains('verification failed'))) {
          clearOtpFields();
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
                return PrimaryButton(
                  width: 250,
                  height: 60,
                  onTap: verifyOtp,
                  text: 'Verify',
                  isLoading: state is AuthLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
