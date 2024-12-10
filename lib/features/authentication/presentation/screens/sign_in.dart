import 'package:flareup/core/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routs.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/widgets/form_feild.dart';
import '../../../../core/widgets/logo_gradient.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../dependency_injector.dart';
import '../../../profile/presentation/bloc/user_profile_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

import '../widgets/auth/google_log.dart';
import '../widgets/auth/sign_up_text.dart';
import 'package:flareup/core/utils/responsive_utils.dart';
import 'package:flareup/core/presentation/helpers/snackbar_helper.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    final authBloc = DependencyInjector().authBloc;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding,
        vertical: Responsive.verticalPadding,
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            SnackbarHelper.showError(context, state.error);
          } else if (state is AuthSuccess) {
            final role = state.userEntity.role;
            if (role == 'user') {
              final userId = state.userEntity.id.toString();
              context.read<UserProfileBloc>().add(LoadUserProfile(userId));
            }
            SnackbarHelper.showSuccess(context, state.message);
            Navigator.pushReplacementNamed(context, AppRouts.home);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: Responsive.screenHeight * 0.15),
                LogoGradientText(fontSize: Responsive.titleFontSize * 2.5),
                SizedBox(height: Responsive.spacingHeight * 1.6),
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
                  hint: 'name',
                  icon: const Icon(Icons.person),
                  controller: nameController,
                  validator: FormValidator.validateUserName,
                ),
                SizedBox(height: Responsive.spacingHeight),
                AppFormField(
                  hint: 'password',
                  icon: const Icon(Icons.lock),
                  isPassword: true,
                  controller: passwordController,
                  validator: FormValidator.validatePassword,
                ),
                SizedBox(height: Responsive.spacingHeight),
                Align(
                  alignment: const Alignment(1.0, 0.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouts.forgotPassword);
                    },
                    child: Text(
                      'Forgot Password',
                      style: AppTextStyles.hindTextTheme(
                        fontSize: Responsive.bodyFontSize,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.spacingHeight * 2),
                PrimaryButton(
                  width: Responsive.screenWidth * 0.85,
                  height: Responsive.buttonHeight,
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
                  fontSize: Responsive.titleFontSize,
                  text: 'Sign in',
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
                SizedBox(height: Responsive.spacingHeight * 2),
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
