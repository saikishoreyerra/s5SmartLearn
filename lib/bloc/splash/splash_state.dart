import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SpalshInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashLoadedState extends SplashState {}

class SplashErrorState extends SplashState {}
