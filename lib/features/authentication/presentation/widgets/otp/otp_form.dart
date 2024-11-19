import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import 'otp_box.dart';

class OtpForm extends StatelessWidget {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers =
        List.generate(6, (index) => TextEditingController());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state is OtpVerificationSuccess) {
        //   Navigator.pushNamedAndRemoveUntil(
        //       context, AppRouts.signIn, (route) => false);
        // } else if (state is AuthFailure) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(state.error)),
        //   );
        // }
      },
      builder: (context, state) {
        final email = state is SignupSuccess
            ? state.email
            : (state as OtpVerificationState).email;

        return Form(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return OtpBox(controller: controllers[index]);
                }),
              ),
              const SizedBox(height: 100),
              PrimaryButton(
                width: 250,
                height: 60,
                onTap: () {
                  String otp =
                      controllers.map((controller) => controller.text).join();
                  context.read<AuthBloc>().add(
                        SendOtpEvent(email: email, otp: otp),
                      );
                },
                text: 'Verify',
              ),
            ],
          ),
        );
      },
    );
  }
}
