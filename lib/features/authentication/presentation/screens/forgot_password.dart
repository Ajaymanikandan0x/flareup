import 'package:flareup/core/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routs.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/form_feild.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.dark 
                ? AppPalette.darkCard 
                : AppPalette.lightCard),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Forgot Password',
          style: AppTextStyles.primaryTextTheme(
            fontSize: Responsive.titleFontSize,
          ),
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
              ),
            );
          } else if (state is ForgotPasswordSuccess) {
            Navigator.pushNamed(
              context,
              AppRouts.otpScreen,
              arguments: {'email': state.email, 'isPasswordReset': true},
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding,
            vertical: Responsive.verticalPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: Responsive.spacingHeight * 2),
                Container(
                  padding: EdgeInsets.all(Responsive.isTablet ? 24 : 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppPalette.myGradient,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: Responsive.isTablet ? 55 : 45,
                    color: Theme.of(context).brightness == Brightness.dark 
                ? AppPalette.darkCard 
                : AppPalette.lightCard,
                  ),
                ),
                SizedBox(height: Responsive.spacingHeight),
                Text(
                  'Please Enter Your Email Address To\nReceive a Verification Code.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.primaryTextTheme(
                    fontSize: Responsive.subtitleFontSize,
                  ),
                ),
                SizedBox(height: Responsive.spacingHeight * 2),
                AppFormField(
                  hint: 'Email Address',
                  icon: const Icon(Icons.email),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return FormValidator.validateEmail(value);
                  },
                ),
                SizedBox(height: Responsive.spacingHeight * 2),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                ForgotPasswordEvent(
                                  email: emailController.text.trim(),
                                ),
                              );
                        }
                      },
                      text: state is AuthLoading ? 'Sending...' : 'Send',
                      width: Responsive.screenWidth * 0.85,
                      height: Responsive.buttonHeight,
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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
