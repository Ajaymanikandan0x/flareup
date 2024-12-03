import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routs.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/utils/validation.dart';
import '../../../../core/widgets/form_feild.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? otp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    email = args['email'] as String;
    otp = args['otp'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Create New Password',
              style: AppTextStyles.primaryTextTheme(fontSize: 20),
            ),
            centerTitle: true,
          ),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: AppPalette.error,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (state is ResetPasswordSuccess) {
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
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/lock.png', height: 100),
                    const SizedBox(height: 20),
                    Text(
                      'Your New Password Must Be Different\nfrom Previously Used Password.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.primaryTextTheme(fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    AppFormField(
                      hint: 'New Password',
                      controller: newPasswordController,
                      validator: FormValidator.validatePassword,
                      isObscureText: true,
                    ),
                    const SizedBox(height: 20),
                    AppFormField(
                      hint: 'Confirm Password',
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value != newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      isObscureText: true,
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          onTap: () {
                            if (_formKey.currentState!.validate() && email != null && otp != null) {
                              context.read<AuthBloc>().add(
                                ResetPasswordEvent(
                                  email: email!,
                                  newPassword: newPasswordController.text,
                                  otp: otp!,
                                ),
                              );
                            }
                          },
                          text: state is AuthLoading ? 'Saving...' : 'Save',
                          width: double.infinity,
                          height: 55,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}