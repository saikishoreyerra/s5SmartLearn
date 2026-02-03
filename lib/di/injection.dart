import 'package:get_it/get_it.dart';

import '../bloc/login/login_bloc.dart';
import '../datasources/assignments_remote_datasource.dart';
import '../datasources/quiz_remote_datasource.dart';
import '../repositories/assignments_repository.dart';
import '../repositories/login_repository.dart';
import '../repositories/quiz_repository.dart';
import '../services/local_storage_service.dart';
import '../services/login_service.dart';
import '../viewmodels/forgot_password_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/assignments_viewmodel.dart';
import '../viewmodels/quiz_viewmodel.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Services
  getIt.registerLazySingleton<ILoginService>(() => LoginService());
  getIt.registerLazySingleton<ILocalStorageService>(
    () => LocalStorageService(),
  );

  // Data sources (remote / API)
  getIt.registerLazySingleton<IQuizRemoteDataSource>(
    () => QuizRemoteDataSource(),
  );
  getIt.registerLazySingleton<IAssignmentsRemoteDataSource>(
    () => AssignmentsRemoteDataSource(),
  );

  // Repositories
  getIt.registerLazySingleton<ILoginRepository>(
    () => LoginRepository(getIt<ILoginService>()),
  );
  getIt.registerLazySingleton<IQuizRepository>(
    () => QuizRepository(getIt<IQuizRemoteDataSource>()),
  );
  getIt.registerLazySingleton<IAssignmentsRepository>(
    () => AssignmentsRepository(getIt<IAssignmentsRemoteDataSource>()),
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
  getIt.registerFactory<QuizViewModel>(
    () => QuizViewModel(getIt<IQuizRepository>()),
  );
  getIt.registerFactory<AssignmentsViewModel>(
    () => AssignmentsViewModel(getIt<IAssignmentsRepository>()),
  );
}
