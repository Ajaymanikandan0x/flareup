import 'package:flareup/core/routes/routs.dart';
import 'package:flareup/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'dependency_injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final pref = await SharedPreferences.getInstance();
  await AppConfig.initialize();
  final injector = DependencyInjector();
  injector.setup();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => DependencyInjector().authBloc),
      BlocProvider(create: (context) => DependencyInjector().userProfileBloc),
      BlocProvider(create: (context) => DependencyInjector().eventBloc),
      BlocProvider(create: (context) => DependencyInjector().singleEventBloc),
      BlocProvider(create: (context) => ThemeCubit(pref)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlareUp',
          theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          onGenerateRoute: AppRouts.generateRoute,
          initialRoute: AppRouts.logo,
          // home: EventLogoScreen(),
        );
      },
    );
  }
}
