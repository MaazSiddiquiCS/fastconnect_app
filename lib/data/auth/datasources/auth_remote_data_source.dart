// data/datasources/auth_remote_data_source.dart
import 'dart:convert';
import 'package:meta/meta.dart';
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../../../core/utils/failure.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  /// Login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final body = {
        'email': email.trim(),
        'password': password,
      };

      final json = await apiClient.post(
        '/auth/login',
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (json == null) throw Failure('Empty response from server');

      return UserModel.fromMap(json as Map<String, dynamic>);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Login failed: $e');
    }
  }

  /// Register – NEW METHOD
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final body = {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      };

      final json = await apiClient.post(
        '/auth/register',
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (json == null) throw Failure('Empty response from server');

      return UserModel.fromMap(json as Map<String, dynamic>);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Registration failed: $e');
    }
  }

  /// Logout
  Future<void> logout({required String token}) async {
    try {
      await apiClient.post(
        '/auth/logout',
        headers: {'Authorization': 'Bearer $token'},
      );
    } on Failure {
      rethrow;
    } catch (e) {
      // We usually don't fail logout even if server is down
      // So we swallow non-Failure errors
    }
  }

  /// Get current user profile
  Future<UserModel> getProfile({required String token}) async {
    try {
      final json = await apiClient.get(
        '/auth/me',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (json == null) throw Failure('Empty response from server');

      return UserModel.fromMap(json as Map<String, dynamic>);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Failed to fetch profile: $e');
    }
  }
}