import 'package:get_it/get_it.dart';

import '../bloc/login/login_bloc.dart';
import '../repositories/login_repository.dart';
import '../services/local_storage_service.dart';
import '../services/login_service.dart';
import '../viewmodels/forgot_password_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Services
  getIt.registerLazySingleton<ILoginService>(() => LoginService());
  getIt.registerLazySingleton<ILocalStorageService>(
    () => LocalStorageService(),
  );

  // Repositories
  getIt.registerLazySingleton<ILoginRepository>(
    () => LoginRepository(getIt<ILoginService>()),
  );

  // BLoC
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      getIt<ILoginRepository>(),
      getIt<ILocalStorageService>(),
    ),
  );

  // ViewModels
  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(getIt<LoginBloc>()),
  );
  getIt.registerFactory<ForgotPasswordViewModel>(
    () => ForgotPasswordViewModel(),
  );
}
