import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/app_config.dart';
import 'dependency_injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();
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
        ),
        BlocProvider(
          create: (context) => DependencyInjector().userProfileBloc,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FlareUp',
        theme: AppTheme.darkTheme,
        onGenerateRoute: AppRouts.generateRoute,
        initialRoute: AppRouts.logo,
        // home: const OtpScreen(),
      ),
    );
  }
}
