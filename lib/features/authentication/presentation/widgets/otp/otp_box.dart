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
      height: 64.0,
      width: 64.0,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.isNotEmpty) {
         
            FocusScope.of(context).nextFocus();
          } else {
            
            FocusScope.of(context).previousFocus();
          }
        },
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "0",
          border: _buildBorder(12.0),
          enabledBorder: _buildBorder(12.0),
          focusedBorder: _buildBorder(12.0, focused: true),
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
