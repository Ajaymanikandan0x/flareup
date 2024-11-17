import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dependency_injector.dart';

void main() {
  final injector = DependencyInjector();
  injector.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DependencyInjector().authBloc,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlareUp',
        theme: AppTheme.darkTheme,
        onGenerateRoute: AppRouts.generateRoute,
        initialRoute: AppRouts.logo,
      ),
    );
  }
}
