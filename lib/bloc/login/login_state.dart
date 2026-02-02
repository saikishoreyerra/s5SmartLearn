import 'package:equatable/equatable.dart';
import '../../models/login_response.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final LoginResponse response;

  const LoginSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class SignInButtonState extends LoginState{
  final bool shouldEnable;
  const SignInButtonState(this.shouldEnable);
  
  @override
  List<Object?> get props => [shouldEnable];
}
