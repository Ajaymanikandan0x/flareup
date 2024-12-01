import 'package:flareup/core/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/routes/routs.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/widgets/logo_gradient.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../dependency_injector.dart';
import '../../../profile/presentation/bloc/user_profile_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/widgets/form_feild.dart';
import '../widgets/auth/google_log.dart';
import '../widgets/auth/sign_up_text.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authBloc = DependencyInjector().authBloc;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is AuthSuccess) {
                     final userId = state.userEntity.id.toString(); 
          context.read<UserProfileBloc>().add(LoadUserProfile(userId));
            // Handle success (navigate to home page)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );

            Navigator.pushReplacementNamed(context, AppRouts.home);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 120),
                const LogoGradientText(fontSize: 50),
                const SizedBox(height: 40),
                Align(
                  alignment: const Alignment(-1, 0.0),
                  child: Text(
                    style: AppTextStyles.primaryTextTheme(fontSize: 30),
                    'Sign in',
                  ),
                ),
                formHeight,
                AppFormField(
                  hint: 'name',
                  icon: const Icon(Icons.person),
                  isObscureText: false,
                  controller: nameController,
                  validator: FormValidator.validateUserName,
                ),
                largeHeight,
                AppFormField(
                  hint: 'password',
                  icon: const Icon(Icons.person_2),
                  isObscureText: true,
                  controller: passwordController,
                  validator: FormValidator.validatePassword,
                ),
                largeHeight,
                Align(
                  alignment: const Alignment(1.0, 0.0),
                  child: Text(
                    'Forgot Password ',
                    style: AppTextStyles.hindTextTheme(),
                  ),
                ),
                largeHeight,
                largeHeight,
                PrimaryButton(
                  width: 320,
                  height: 60,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (nameController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill in all fields")),
                        );
                      } else {
                        authBloc.add(LoginEvent(
                            username: nameController.text,
                            password: passwordController.text));
                      }
                    }
                  },
                  fontSize: 20,
                  text: 'Sign in',
                ),
                largeHeight,
                Text(
                  'or',
                  style: AppTextStyles.hindTextTheme(fontSize: 20),
                ),
                formHeight,
                const GoogleSignInButton(),
                extraLargeHeight,
                minHeight,
                AuthPromptText(
                  prefixText: 'Don\'t have an account?',
                  suffixText: 'Sign Up',
                  onTap: () {
                    Navigator.pushNamed(context, AppRouts.signUp);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
