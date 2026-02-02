import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/login_repository.dart';
import '../../services/local_storage_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ILoginRepository _loginRepository;
  final ILocalStorageService _localStorageService;

  LoginBloc(this._loginRepository, this._localStorageService)
    : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
    on<OnFieldValidationEvent>(_onValidatingFields);
  }

  void _onValidatingFields(
    OnFieldValidationEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(SignInButtonState(event.isValidate ?? false));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    try {
      final response = await _loginRepository.login(
        event.username,
        event.password,
      );

      if (response.suc) {
        await _localStorageService.saveLoginResponse(response, event.password);
        emit(LoginSuccess(response));
      } else {
        emit(LoginFailure(response.err ?? 'Login failed'));
        // Restore validation state after failure
        final isValid =
            event.username.trim().length > 4 &&
            event.password.trim().length >= 8;
        emit(SignInButtonState(isValid));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
      // Restore validation state after error
      final isValid =
          event.username.trim().length > 4 && event.password.trim().length >= 8;
      emit(SignInButtonState(isValid));
    }
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginInitial());
  }
}
