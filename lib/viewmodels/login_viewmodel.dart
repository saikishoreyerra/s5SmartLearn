import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';

class LoginViewModel {
  final LoginBloc loginBloc;

  LoginViewModel(this.loginBloc);

  void login(String username, String password) {
    loginBloc.add(LoginSubmitted(username: username, password: password));
  }

  void reset() {
    loginBloc.add(const LoginReset());
  }

  Stream<LoginState> get loginState => loginBloc.stream;
}
