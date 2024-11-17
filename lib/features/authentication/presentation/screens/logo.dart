import 'dart:async';

import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/widgets/logo_gradient.dart';
import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 5),
        () => Navigator.pushNamed((context), AppRouts.onBoard));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: LogoGradientText(
        fontSize: 40,
      )),
    );
  }
}
