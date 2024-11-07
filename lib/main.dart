import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlareUp',
      theme: AppTheme.darkTheme,
      onGenerateRoute: AppRouts.generateRoute,
      initialRoute: AppRouts.logo,
    );
  }
}
