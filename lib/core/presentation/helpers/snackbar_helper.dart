import 'package:flutter/material.dart';

class SnackbarHelper {
  static bool _isSnackbarVisible = false;

  static void showError(BuildContext context, String message) {
    if (!_isSnackbarVisible) {
      _isSnackbarVisible = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
          onVisible: () {
            Future.delayed(const Duration(seconds: 3), () {
              _isSnackbarVisible = false;
            });
          },
        ),
      );
    }
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      ),
    );
  }
} 