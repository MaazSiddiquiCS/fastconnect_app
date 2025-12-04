import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call({required String token}) {
    return repository.logout(token: token);
  }
}
