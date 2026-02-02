// import 'package:equatable/equatable.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s5learn_ai/bloc/splash/splash_event.dart';
import 'package:s5learn_ai/bloc/splash/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SpalshInitialState()) {
    on<SplashStartEvent>(_onSplashStartEvent);
  }

  Future<void> _onSplashStartEvent(
    SplashStartEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoadingState());

    await Future.delayed(const Duration(seconds: 2));

    if (event.isLoggedIn) {
      emit(SplashLoadedState());
    } else {
      emit(SplashErrorState());
    }
  }
}
