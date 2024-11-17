import 'package:flareup/core/constants/constants.dart';
import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/utils/validation.dart';
import 'package:flareup/core/widgets/primary_button.dart';
import 'package:flareup/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flareup/features/authentication/presentation/widgets/auth/form_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/text_theme.dart';
import '../../../../dependency_injector.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth/google_log.dart';
import '../widgets/auth/sign_up_text.dart';

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
    final authBloc = DependencyInjector().authBloc;

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );

            Navigator.pushReplacementNamed(context, AppRouts.home);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: const Alignment(-1, 0.0),
                    child: Text(
                      style: AppTextStyles.primaryTextTheme(fontSize: 30),
                      'Sign in',
                    ),
                  ),
                  largeHeight,
                  AppFormField(
                      hint: 'userName',
                      icon: const Icon(Icons.person),
                      isObscureText: false,
                      controller: nameController,
                      validator: FormValidator.validateUserName),
                  largeHeight,
                  AppFormField(
                    hint: 'fullName',
                    icon: const Icon(Icons.person_2),
                    isObscureText: false,
                    controller: fullNameController,
                    validator: FormValidator.validateName,
                  ),
                  largeHeight,
                  AppFormField(
                      hint: 'abc@Gmail.com',
                      icon: const Icon(Icons.email),
                      isObscureText: false,
                      controller: emailController,
                      validator: FormValidator.validateEmail),
                  largeHeight,
                  AppFormField(
                    hint: 'your password',
                    icon: const Icon(Icons.lock),
                    isObscureText: true,
                    controller: passwordController,
                    validator: FormValidator.validatePassword,
                  ),
                  largeHeight,
                  AppFormField(
                    hint: 'Conform password',
                    icon: const Icon(Icons.lock),
                    isObscureText: true,
                    controller: passwordConformController,
                    validator: FormValidator.validatePassword,
                  ),
                  largeHeight,
                  minHeight,
                  PrimaryButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (passwordController.text ==
                            passwordConformController.text) {
                          authBloc.add(SignupEvent(
                              username: nameController.text,
                              role: 'user',
                              email: emailController.text,
                              password: passwordConformController.text,
                              fullName: fullNameController.text));
                          print('call');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Passwords do not match")),
                          );
                        }
                      }
                    },
                    text: 'Sign up',
                    height: 65,
                    width: 350,
                  ),
                  largeHeight,
                  minHeight,
                  Text(
                    'or',
                    style: AppTextStyles.hindTextTheme(fontSize: 20),
                  ),
                  formHeight,
                  const GoogleSignInButton(),
                  largeHeight,
                  minHeight,
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
