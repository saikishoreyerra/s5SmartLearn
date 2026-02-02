import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class SplashStartEvent extends SplashEvent {
  const SplashStartEvent({this.isLoggedIn = false});
  final bool isLoggedIn;

  @override
  List<Object> get props => [isLoggedIn];
}
