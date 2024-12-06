import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppFormField extends StatefulWidget {
  final Icon? icon;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;

  const AppFormField({
    super.key,
    required this.hint,
    this.icon,
    this.isPassword = false,
    required this.controller,
    this.validator,
  });

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyles.primaryTextTheme(),
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.hint,
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
        hintText: widget.hint,
        prefixIcon: widget.icon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                tooltip: _obscureText ? 'Show password' : 'Hide password',
              )
            : null,
        helperText: widget.isPassword ? 'Use a strong password' : null,
      ),
    );
  }
}
