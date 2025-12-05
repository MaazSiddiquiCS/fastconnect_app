import 'package:meta/meta.dart';
import '../../../core/utils/failure.dart';
import '../../../domain/auth/entities/user.dart';
// NOTE: Assuming this file exists and contains the User entity and AuthResult class
import '../../../domain/auth/entities/auth_result.dart'; 
import '../../../domain/auth/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

// NOTE: Ensure your AuthRepository interface uses Future<AuthResult> for login/register.

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  
  // Removed: final AuthMockDataSource mock;
  // Removed: final bool useMock;

  AuthRepositoryImpl({
    required this.remote,
    required this.local,
  });

  // --- Login ---
  @override
  Future<AuthResult> login({required String email, required String password}) async {
    try {
      // Direct call to the actual remote data source
      final AuthResponse response = await remote.login(email: email, password: password);
      
      // Save user and token locally.
      await local.cacheUser(response.user, response.accessToken);
      
      return AuthResult(
        user: response.user,
        accessToken: response.accessToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // --- Logout ---
  @override
  Future<void> logout({required String token}) async {
    try {
      // Direct call to the actual remote data source
      await remote.logout(token: token);
    } finally {
      // Always clear local data
      await local.deleteUser();
      await local.deleteToken();
    }
  }

  // --- Get Profile ---
  @override
  Future<User> getProfile({required String token}) async {
    // 1. Try local cache first
    final localUser = await local.getCurrentUser();
    if (localUser != null) return localUser;

    // 2. Then remote
    final UserModel user = await remote.getProfile(token: token);

    // Cache the retrieved user data and update the token
    await local.cacheUser(user, token); 
    return user;
  }
  
  // --- Register ---
  @override
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Direct call to the actual remote data source
      final AuthResponse response = await remote.register(
        name: name,
        email: email,
        password: password,
      );
      
      // Save user and token locally.
      await local.cacheUser(response.user, response.accessToken);

      return AuthResult(
        user: response.user,
        accessToken: response.accessToken,
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure('Failed to register: $e');
    }
  }
}