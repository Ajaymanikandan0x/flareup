import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/utils/validation.dart';
import 'package:flareup/core/widgets/primary_button.dart';
import 'package:flareup/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flareup/core/widgets/form_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/text_theme.dart';
import '../../../../core/widgets/password_field.dart';
import '../../../../dependency_injector.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth/google_log.dart';
import '../widgets/auth/sign_up_text.dart';
import '../../../../core/utils/responsive_utils.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConformController = TextEditingController();
  final fullNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);
    final authBloc = DependencyInjector().authBloc;

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pushReplacementNamed(
              context, 
              AppRouts.otpScreen,
              arguments: {
                'email': state.email,
                'isPasswordReset': false,
              },
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding,
              vertical: Responsive.verticalPadding,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: Responsive.spacingHeight * 2),
                  Align(
                    alignment: const Alignment(-1, 0.0),
                    child: Text(
                      'Sign in',
                      style: AppTextStyles.primaryTextTheme(
                        fontSize: Responsive.titleFontSize,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.spacingHeight),
                  AppFormField(
                      hint: 'userName',
                      icon: const Icon(Icons.person),
                      controller: nameController,
                      validator: FormValidator.validateUserName),
                  SizedBox(height: Responsive.spacingHeight),
                  AppFormField(
                    hint: 'fullName',
                    icon: const Icon(Icons.person_2),
                    controller: fullNameController,
                    validator: FormValidator.validateName,
                  ),
                  SizedBox(height: Responsive.spacingHeight),
                  AppFormField(
                      hint: 'abc@Gmail.com',
                      icon: const Icon(Icons.email),
                      controller: emailController,
                      validator: FormValidator.validateEmail),
                  SizedBox(height: Responsive.spacingHeight),
                  PasswordField(
                    hint: 'your password',
                    icon: const Icon(Icons.lock),
                    controller: passwordController,
                    validator: FormValidator.validatePassword,
                  ),
                  SizedBox(height: Responsive.spacingHeight),
                  PasswordField(
                    hint: 'Conform password',
                    controller: passwordConformController,
                    icon: const Icon(Icons.lock),
                    validator: FormValidator.validatePassword,
                  ),
                  SizedBox(height: Responsive.spacingHeight),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final bool isLoading = state is AuthLoading;
                      return PrimaryButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (passwordController.text ==
                                passwordConformController.text) {
                            
                              // Ensure correct mapping
                              final email = emailController.text.trim();
                              final fullName = fullNameController.text.trim();
                              final username = nameController.text.trim();
                              final password =
                                  passwordConformController.text.trim();

                              authBloc.add(SignupEvent(
                                username: username,
                                role: 'user',
                                email: email,
                                password: password,
                                fullName: fullName,
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Passwords do not match")),
                              );
                            }
                          }
                        },
                        text: 'Sign up',
                        height: Responsive.buttonHeight,
                        width: Responsive.screenWidth * 0.85,
                        isLoading: isLoading,
                        isEnabled: !isLoading,
                      );
                    },
                  ),
                  SizedBox(height: Responsive.spacingHeight),
                  Text(
                    'or',
                    style: AppTextStyles.hindTextTheme(
                      fontSize: Responsive.subtitleFontSize,
                    ),
                  ),
                  SizedBox(height: Responsive.spacingHeight),
                  const GoogleSignInButton(),
                  SizedBox(height: Responsive.spacingHeight),
                  AuthPromptText(
                    prefixText: 'Already have an account? ',
                    suffixText: 'Sign In',
                    onTap: () {
                      Navigator.pushNamed(context, AppRouts.signIn);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
