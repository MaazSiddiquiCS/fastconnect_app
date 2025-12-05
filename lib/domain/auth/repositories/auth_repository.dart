import '../entities/user.dart';
// NOTE: Assuming AuthResult is defined in this domain layer
import '../entities/auth_result.dart'; 

abstract class AuthRepository {
  
  // FIX: Change return type from Future<User> to Future<AuthResult>
  // AuthResult contains both the User entity and the Access Token.
  Future<AuthResult> login({required String email, required String password});
  
  Future<void> logout({required String token});
  
  // FIX: The repository now returns AuthResult
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  });

  // Keep Future<User> for getProfile, as this typically returns only user data, 
  // relying on an existing token (which is passed in).
  Future<User> getProfile({required String token});
}