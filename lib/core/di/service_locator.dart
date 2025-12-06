import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../data/auth/datasources/auth_local_data_source.dart';
import '../../data/auth/datasources/auth_remote_data_source.dart';
import '../../data/auth/datasources/user_remote_data_source.dart';
import '../../data/auth/repositories/auth_repository_impl.dart';
import '../../data/reels/datasources/reels_remote_data_source.dart';
import '../../data/reels/repositories/reel_repository.dart';
import '../../domain/auth/repositories/auth_repository.dart';
import '../../domain/auth/usecases/login.dart';
import '../../domain/auth/usecases/logout.dart';
import '../../domain/auth/usecases/get_logged_in_user.dart';
import '../../domain/auth/usecases/register.dart';
import '../../domain/reels/repositories/reel_repository.dart';
import '../../domain/reels/usecases/get_popular_reels.dart';
import '../network/api_client.dart';
import '../utils/constants.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../domain/profile/repositories/profile_repository.dart';
import '../../domain/profile/usecases/get_profile.dart';
import '../../domain/profile/usecases/update_profile.dart';
import '../../domain/profile/usecases/upload_profile_picture.dart';
import '../../domain/profile/usecases/upload_cover_photo.dart';
import '../../data/profile/datasources/profile_remote_data_source.dart';
import '../../data/profile/repositories/profile_repository_impl.dart';
import '../../presentation/profile/bloc/profile_bloc.dart';

// --- NEW REELS IMPORTS ---
import '../../data/reels/repositories/reel_repository_impl.dart';
import '../../presentation/reels/bloc/reel_bloc.dart';
// -------------------------

final locator = GetIt.instance;

Future<void> setupLocator() async {
  // ---------------- Core Firebase Instances ----------------
  locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  
  // ---------------- Local Storage/DB ----------------
  // 1. Initialize SharedPreferences instance and register its Future
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<Future<SharedPreferences>>(() => Future.value(sharedPreferences));
  
  // 2. Register AuthLocalDataSource, passing the Future<SharedPreferences> dependency
  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(locator<Future<SharedPreferences>>()),
  );

  // ---------------- Network (Kept for other future API calls) ----------------
  const String baseUrl = AppConstants.baseUrl;
  locator.registerLazySingleton<http.Client>(() => http.Client()); 
  locator.registerLazySingleton<ApiClient>(() => ApiClient(
    baseUrl: baseUrl,
    client: locator<http.Client>(),
  ));

  // ---------------- Data Sources ----------------
  locator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(firestore: locator<FirebaseFirestore>()),
  );
  
  // AuthRemoteDataSource only needs FirebaseAuth for the core credential check
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(
      auth: locator<FirebaseAuth>(),
      userDataSource: locator<UserRemoteDataSource>(), 
      apiClient: locator<ApiClient>(), 
    ),
  );

  // ---------------- Repositories ----------------
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: locator<AuthRemoteDataSource>(),
      local: locator<AuthLocalDataSource>(),
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

  // ---------------- Profile Module ----------------
  locator.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  locator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firestore: locator<FirebaseFirestore>(),
      storage: locator<FirebaseStorage>(),
    ),
  );

  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: locator<ProfileRemoteDataSource>()),
  );

  locator.registerLazySingleton<GetProfile>(() => GetProfile(locator<ProfileRepository>()));
  locator.registerLazySingleton<UpdateProfile>(() => UpdateProfile(locator<ProfileRepository>()));
  locator.registerLazySingleton<UploadProfilePicture>(() => UploadProfilePicture(locator<ProfileRepository>()));
  locator.registerLazySingleton<UploadCoverPhoto>(() => UploadCoverPhoto(locator<ProfileRepository>()));

  locator.registerFactory<ProfileBloc>(() => ProfileBloc(
    getProfileUseCase: locator<GetProfile>(),
    updateProfileUseCase: locator<UpdateProfile>(),
    uploadProfilePictureUseCase: locator<UploadProfilePicture>(),
    uploadCoverPhotoUseCase: locator<UploadCoverPhoto>(),
  ));
  
  // ---------------- Reels Module ----------------
// Reels DI
//locator.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: AppConstants.pexelsBaseUrl, client: locator<http.Client>()));
locator.registerLazySingleton<ReelsRemoteDataSource>(() => ReelsRemoteDataSourceImpl(client: locator<ApiClient>()));
locator.registerLazySingleton<ReelsRepository>(() => ReelsRepositoryImpl(remote: locator<ReelsRemoteDataSource>()));
// SharedPreferences already registered? else:
final prefs = await SharedPreferences.getInstance();
locator.registerLazySingleton<SharedPreferences>(() => prefs);
locator.registerFactory<ReelsBloc>(() => ReelsBloc(getPopularReels: GetPopularReels(locator<ReelsRepository>()), prefs: locator<SharedPreferences>()));

}