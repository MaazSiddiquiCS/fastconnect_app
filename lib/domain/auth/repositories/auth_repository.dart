import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<void> logout({required String token});
  Future<User> getProfile({required String token});
  Future<User> register({
  required String name,
  required String email,
  required String password,
});
}
