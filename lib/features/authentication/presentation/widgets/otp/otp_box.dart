import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/utils/responsive_utils.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;

  const OtpBox({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    // Calculate responsive dimensions
    final boxSize = Responsive.isTablet ? 72.0 : 64.0;
    final fontSize = Responsive.isTablet ? 24.0 : 20.0;
    final borderRadius = Responsive.isTablet ? 16.0 : 12.0;

    return SizedBox(
      height: boxSize,
      width: boxSize,
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
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppPalette.lightCard,
              fontSize: fontSize,
            ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "0",
          hintStyle: TextStyle(
            color: AppPalette.lightCard,
            fontSize: fontSize,
          ),
          border: _buildBorder(borderRadius),
          enabledBorder: _buildBorder(borderRadius),
          focusedBorder: _buildBorder(borderRadius, focused: true),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(double radius, {bool focused = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: AppPalette.gradient2,
        width: focused ? 2.0 : 1.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }
}
