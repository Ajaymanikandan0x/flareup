import 'dart:async';

import 'package:flareup/core/routes/routs.dart';
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
        child: Text(
          "flare Up",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
