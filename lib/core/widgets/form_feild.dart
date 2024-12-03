import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppFormField extends StatefulWidget {
  final Icon? icon;
  final String hint;
  final bool isObscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AppFormField({
    super.key,
    required this.hint,
    this.icon,
    required this.isObscureText,
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
    _obscureText = widget.isObscureText;
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
        suffixIcon: widget.isObscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              )
            : null,
      ),
    );
  }
}