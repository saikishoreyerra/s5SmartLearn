import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s5learn_ai/bloc/splash/splash_bloc.dart';
import 'package:s5learn_ai/bloc/splash/splash_event.dart';
import 'package:s5learn_ai/bloc/splash/splash_state.dart';
import 'package:s5learn_ai/models/user.dart';
import 'package:s5learn_ai/views/dashboard_page.dart';
import 'package:s5learn_ai/views/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.user});
  final User? user;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(
          SplashStartEvent(isLoggedIn: widget.user != null),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashLoadedState && widget.user != null) {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  DashboardPage(user: widget.user!),
            ),
          );
        } else if (state is SplashErrorState) {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SizedBox.expand(
            child: Image.asset(
              'assets/images/latest_splash.png',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
