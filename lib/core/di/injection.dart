import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ws_test/core/constants/app_constants.dart';
import 'package:ws_test/data/datasources/local/settings_local_ds.dart';
import 'package:ws_test/data/datasources/remote/path_task_remote_ds.dart';
import 'package:ws_test/data/repositories/path_task_repository_impl.dart';
import 'package:ws_test/data/repositories/settings_repository_impl.dart';
import 'package:ws_test/domain/repositories/path_task_repository.dart';
import 'package:ws_test/domain/repositories/settings_repository.dart';
import 'package:ws_test/domain/services/path_finder.dart';
import 'package:ws_test/domain/usecases/fetch_tasks.dart';
import 'package:ws_test/domain/usecases/get_saved_api_url.dart';
import 'package:ws_test/domain/usecases/save_api_url.dart';
import 'package:ws_test/domain/usecases/send_results.dart';
import 'package:ws_test/domain/usecases/solve_tasks.dart';
import 'package:ws_test/domain/usecases/validate_api_url.dart';
import 'package:ws_test/presentation/screens/home/home_cubit.dart';
import 'package:ws_test/presentation/screens/process/process_cubit.dart';
import 'package:ws_test/presentation/session/path_session.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();
  final settingsBox = await Hive.openBox<dynamic>(AppConstants.settingsBoxName);

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    ),
  );

  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(settingsBox),
  );
  getIt.registerLazySingleton<PathTaskRemoteDataSource>(
    () => PathTaskRemoteDataSource(getIt()),
  );

  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<PathTaskRepository>(
    () => PathTaskRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<PathFinder>(PathFinder.new);
  getIt.registerLazySingleton<PathSession>(PathSession.new);

  getIt.registerLazySingleton<ValidateApiUrl>(ValidateApiUrl.new);
  getIt.registerLazySingleton(() => GetSavedApiUrl(getIt()));
  getIt.registerLazySingleton(() => SaveApiUrl(getIt()));
  getIt.registerLazySingleton(() => FetchTasks(getIt()));
  getIt.registerLazySingleton(() => SolveTasks(getIt()));
  getIt.registerLazySingleton(() => SendResults(getIt()));

  getIt.registerFactory(
    () => HomeCubit(
      validateApiUrl: getIt(),
      getSavedApiUrl: getIt(),
      saveApiUrl: getIt(),
    ),
  );
  getIt.registerFactory(
    () => ProcessCubit(
      getSavedApiUrl: getIt(),
      fetchTasks: getIt(),
      solveTasks: getIt(),
      sendResults: getIt(),
      session: getIt(),
    ),
  );
}
