import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_palette.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;

  const OtpBox({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 64,
      child: TextFormField(
        controller: controller,
        onChanged: (pin) {
          if (pin.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "0",
          hintStyle: const TextStyle(color: AppPalette.white),
          border: _authOutlineInputBorder,
          enabledBorder: _authOutlineInputBorder,
          focusedBorder: _authOutlineInputBorder.copyWith(
            borderSide: const BorderSide(
              color: AppPalette.gradient2,
              width: 2.0, // Adjust the width as needed
            ),
          ),
        ),
      ),
    );
  }

  static OutlineInputBorder get _authOutlineInputBorder =>
      const OutlineInputBorder(
        borderSide: BorderSide(color: AppPalette.gradient2),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      );
}
