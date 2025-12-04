// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../data/auth/datasources/auth_local_data_source.dart';
import '../../data/auth/datasources/auth_mock_data_source.dart';
import '../../data/auth/datasources/auth_remote_data_source.dart';
import '../../data/auth/repositories/auth_repository_impl.dart';
import '../../domain/auth/repositories/auth_repository.dart';
import '../../domain/auth/usecases/login.dart';
import '../../domain/auth/usecases/logout.dart';
import '../../domain/auth/usecases/get_logged_in_user.dart';
import '../../domain/auth/usecases/register.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import '../utils/constants.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // Use constant from constants.dart for consistency
locator.registerLazySingleton<AppDatabase>(() => AppDatabase.instance);
  locator.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(AppDatabase.instance));

  const String baseUrl = AppConstants.baseUrl;

  // ---------------- Network ----------------
  locator.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: baseUrl));

  // ---------------- Data Sources ----------------
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(apiClient: locator<ApiClient>()),  // Explicit type for clarity
  );

  // ---------------- Repositories ----------------
locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: locator<AuthRemoteDataSource>(),
      local: locator<AuthLocalDataSource>(),
      mock: AuthMockDataSource(),
      useMock: false, // Set to false for real + local storage
    ),
  );

  // ---------------- Use Cases ----------------
  locator.registerLazySingleton<Login>(() => Login(locator<AuthRepository>()));
  locator.registerLazySingleton<Logout>(() => Logout(locator<AuthRepository>()));
  locator.registerLazySingleton<GetLoggedInUser>(() => GetLoggedInUser(locator<AuthRepository>()));
  locator.registerLazySingleton<Register>(() => Register(locator<AuthRepository>()));

  // ---------------- Bloc ----------------
  locator.registerFactory<AuthBloc>(() => AuthBloc(
        loginUseCase: locator<Login>(),
        logoutUseCase: locator<Logout>(),
        getUserUseCase: locator<GetLoggedInUser>(),
        registerUseCase: locator<Register>()
      ));
}