import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // NEW IMPORT

import '../../data/auth/datasources/auth_local_data_source.dart';
import '../../data/auth/datasources/auth_remote_data_source.dart';
import '../../data/auth/datasources/user_remote_data_source.dart';
// import '../../data/user/datasources/user_remote_data_source.dart'; // NEW
import '../../data/auth/repositories/auth_repository_impl.dart';
import '../../domain/auth/repositories/auth_repository.dart';
import '../../domain/auth/usecases/login.dart';
import '../../domain/auth/usecases/logout.dart';
import '../../domain/auth/usecases/get_logged_in_user.dart';
import '../../domain/auth/usecases/register.dart';
// Feed imports
import '../../data/feed/datasources/feed_remote_data_source.dart';
import '../../data/feed/repositories/feed_repository_impl.dart';
import '../../domain/feed/repositories/feed_repository.dart';
import '../../domain/feed/usecases/get_feed_posts.dart';
import '../../domain/feed/usecases/like_post.dart';
import '../../domain/feed/usecases/unlike_post.dart';
import '../../domain/feed/usecases/comment_on_post.dart';
import '../../presentation/feed/bloc/feed_bloc.dart';
// import '../database/app_database.dart'; // REMOVED: No longer using sqflite
import '../network/api_client.dart';
import '../utils/constants.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';

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

  // Feed Data Sources
  locator.registerLazySingleton<FeedRemoteDataSource>(
    () => FeedRemoteDataSourceImpl(firestore: locator<FirebaseFirestore>()),
  );

  // Feed Repositories
  locator.registerLazySingleton<FeedRepository>(
    () {
      final impl = FeedRepositoryImpl(remoteDataSource: locator<FeedRemoteDataSource>());
      return impl as FeedRepository;
    },
  );

  // Feed Use Cases
  locator.registerLazySingleton<GetFeedPosts>(() => GetFeedPosts(locator<FeedRepository>()));
  locator.registerLazySingleton<LikePost>(() => LikePost(locator<FeedRepository>()));
  locator.registerLazySingleton<UnlikePost>(() => UnlikePost(locator<FeedRepository>()));
  locator.registerLazySingleton<CommentOnPost>(() => CommentOnPost(locator<FeedRepository>()));

  // ---------------- Bloc ----------------
  locator.registerFactory<AuthBloc>(() => AuthBloc(
        loginUseCase: locator<Login>(),
        logoutUseCase: locator<Logout>(),
        getUserUseCase: locator<GetLoggedInUser>(),
        registerUseCase: locator<Register>()
      ));

  // Feed Bloc
  locator.registerFactory<FeedBloc>(() => FeedBloc(
    getFeedPosts: locator<GetFeedPosts>(),
    likePost: locator<LikePost>(),
    unlikePost: locator<UnlikePost>(),
    commentOnPost: locator<CommentOnPost>(),
  ));
}