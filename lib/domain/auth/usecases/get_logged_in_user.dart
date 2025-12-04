import '../../auth/entities/user.dart';
import '../repositories/auth_repository.dart';

class GetLoggedInUser {
  final AuthRepository repository;

  GetLoggedInUser(this.repository);

  Future<User> call({required String token}) {
    return repository.getProfile(token: token);
  }
}
