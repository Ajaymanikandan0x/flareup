import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../theme/text_theme.dart';

import '../utils/validation.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final FormFieldValidator<String>? validator;
  final Icon? icon;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.icon,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator ?? FormValidator.validatePassword,
      style: AppTextStyles.primaryTextTheme(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.hint,
        hintText: widget.hint,
        filled: true,
        fillColor: theme.cardColor,
        prefixIcon: widget.icon != null
            ? Icon(
                widget.icon!.icon,
                color: theme.brightness == Brightness.dark
                    ? AppPalette.darkHint
                    : AppPalette.lightHint,
              )
            : null,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: theme.brightness == Brightness.dark
                ? AppPalette.darkHint
                : AppPalette.lightHint,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
          tooltip: _obscureText ? 'Show password' : 'Hide password',
        ),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: theme.brightness == Brightness.dark
                ? AppPalette.darkDivider
                : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppPalette.gradient2, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppPalette.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppPalette.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 23,
          horizontal: 23,
        ),
        helperText: 'Use a strong password',
      ),
    );
  }
} 