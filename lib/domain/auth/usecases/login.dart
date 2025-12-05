import '../entities/user.dart';
import '../entities/auth_result.dart'; // Import the new result class
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  // FIX: Change return type from Future<User> to Future<AuthResult>
  Future<AuthResult> call({required String email, required String password}) {
    // The repository handles the logic of calling Firebase, fetching profile, 
    // and caching the user/token.
    return repository.login(email: email, password: password);
  }
}