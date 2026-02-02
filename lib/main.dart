import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:s5learn_ai/bloc/splash/splash_bloc.dart';
import 'package:s5learn_ai/views/splash_screen.dart';

import 'di/injection.dart';
import 'models/user.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setupDependencyInjection();

  // Decide initial screen based on saved login
  final localStorage = getIt<ILocalStorageService>();
  final savedResponse = await localStorage.getLoginResponse();
  final User? initialUser =
      (savedResponse != null && savedResponse.suc && savedResponse.res != null)
      ? savedResponse.res
      : null;

  runApp(MyApp(initialUser: initialUser));
  // FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final User? initialUser;

  const MyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: AppRoutes,
      title: 'S5Learn AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF08306D)),
        useMaterial3: true,
        fontFamily: 'Source Sans 3',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Bebas Neue',
            fontSize: 36,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
          ),
        ),
      ),
      home: BlocProvider(
        create: (_) => SplashBloc(),
        child: SplashScreen(user: initialUser),
      ),
    );
  }
}

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
}
