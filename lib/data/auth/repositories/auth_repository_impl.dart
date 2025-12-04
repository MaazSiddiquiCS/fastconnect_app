import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/failure.dart';
import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_mock_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  final AuthMockDataSource mock;
  final bool useMock;

  AuthRepositoryImpl({
    required this.remote,
    required this.local,
    required this.mock,
    this.useMock = false,
  });

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      User user;
      if (useMock) {
        user = await mock.login(email: email, password: password);
      } else {
        user = await remote.login(email: email, password: password);
      }

      // Save to SQLite
      await local.cacheUser(user as UserModel);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout({required String token}) async {
    try {
      if (!useMock) {
        await remote.logout(token: token);
      }
    } finally {
      await local.deleteUser(); // Always clear local
    }
  }

  @override
  Future<User> getProfile({required String token}) async {
    // First try local
    final localUser = await local.getCurrentUser();
    if (localUser != null) return localUser;

    // Then remote
    final user = useMock
        ? await mock.getProfile(token: token)
        : await remote.getProfile(token: token);

    await local.cacheUser(user as UserModel);
    return user;
  }
  // data/repositories/auth_repository_impl.dart

@override
Future<User> register({
  required String name,
  required String email,
  required String password,
}) async {
  try {
    // For now: local-only registration (no backend)
    final user = UserModel(
      id: const Uuid().v4(),
      name: name,
      email: email,
      token: const Uuid().v4(), // fake JWT token
      rollNumber: "",
      avatarUrl: null,
    );

    // Save user locally in SQLite
    await local.cacheUser(user);

    return user;
  } catch (e) {
    throw Failure('Failed to register locally: $e');
  }
}
}