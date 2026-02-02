import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:s5learn_ai/bloc/login/login_event.dart';

import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_state.dart';
import '../di/injection.dart';
import '../models/login_response.dart';
import '../services/local_storage_service.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/app_button.dart';
import 'dashboard_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late LoginViewModel _viewModel;
  late ILocalStorageService _localStorageService;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<LoginViewModel>();
    _localStorageService = getIt<ILocalStorageService>();
    _prefillCredentials();
  }

  Future<void> _prefillCredentials() async {
    final savedResponse = await _localStorageService.getLoginResponse();
    final savedPassword = await _localStorageService.getSavedPassword();

    if (savedResponse?.res != null) {
      _usernameController.text = savedResponse!.res!.unm;
    }
    if (savedPassword != null && savedPassword.isNotEmpty) {
      _passwordController.text = savedPassword;
    }
    
    // Trigger validation after prefilling credentials
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _validateForm();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _viewModel.loginBloc.close();
    super.dispose();
  }

  void _handleLogin() {
    // if (_formKey.currentState!.validate()) {
      _viewModel.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );
    // }
  }

  void _validateForm() {
    final isValid =
        _usernameController.text.trim().length > 4 &&
        _passwordController.text.trim().length >= 8;

    _viewModel.loginBloc.add(OnFieldValidationEvent(isValidate: isValid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>.value(
        value: _viewModel.loginBloc,
        child: BlocConsumer<LoginBloc, LoginState>(
          buildWhen: (previous, current) {
            // Always rebuild when state type changes
            if (previous.runtimeType != current.runtimeType) {
              return true;
            }
            // Rebuild when validation state value changes
            if (previous is SignInButtonState && current is SignInButtonState) {
              return previous.shouldEnable != current.shouldEnable;
            }
            // Rebuild for other state changes
            return previous != current;
          },
          listener: (context, state) {
            if (state is LoginSuccess) {
              _navigateToDashboard(context, state.response);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF526E98), Color(0xFF08306D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 24.0),
                  child:
                    _buildContent(context,state),
                  
                   
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context,LoginState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            'Hi Student',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.white,
              fontFamily: 'Source Sans 3 ',
              fontSize: 34,
              fontWeight: FontWeight.w600,
              // letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            'Sign in to continue',
            style: TextStyle(
              fontFamily: 'Source Sans 3',
              color: Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 36),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                      fontFamily: 'Source Sans 3',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF6B6B6B),
                    ),
                    border: const UnderlineInputBorder(),
                  ),
                  onChanged: (_) => _validateForm(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontFamily: 'Source Sans 3',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF6B6B6B),
                    ),
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        'assets/icons/eye_icon.png',
                        width: 20,
                        height: 20,
                        color: Color(0xFF6B6B6B),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,

                  onChanged: (_) => _validateForm(),
                  //
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'SIGN IN',
                  isLoading: state is LoginLoading,
                  enabled: state is SignInButtonState ? state.shouldEnable : false,
                  onPressed: _handleLogin,
                  trailingAtEnd: true,
                  trailing: SvgPicture.asset(
                    'assets/icons/right1.svg',
                    width: 16,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.black87,
                      BlendMode.srcIn,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Source Sans 3',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.14),
              ],
            ),
          ),
        ), // Extra white area below the card to match the desig
      ],
    );
  }

  void _navigateToDashboard(BuildContext context, LoginResponse response) {
    final user = response.res;
    if (user == null) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => DashboardPage(user: user)),
    );
  }
}
