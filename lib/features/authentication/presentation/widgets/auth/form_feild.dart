import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  final Icon? icon;
  final String hint;
  late bool isObscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  AppFormField(
      {super.key,
      required this.hint,
      this.icon,
      required this.isObscureText,
      required this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyles.primaryTextTheme(),
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      validator: validator,
      obscureText: isObscureText,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: AppPalette.hintTextColor),
        filled: true,
        fillColor: AppPalette.cardColor,
        border: InputBorder.none,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: AppPalette.gradient2, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 23, horizontal: 23),
        hintText: hint,
        prefixIcon: icon,
        suffixIcon: IconButton(
          onPressed: () {
            isObscureText = !isObscureText;
          },
          icon: Icon(isObscureText ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}
