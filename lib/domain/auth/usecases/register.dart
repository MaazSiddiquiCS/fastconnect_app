// domain/auth/usecases/register.dart
import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'package:uuid/uuid.dart'; // Add this dependency: uuid: ^4.2.1

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await repository.register(
        name: name,
        email: email,
        password: password,
      );
      return Right(user);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}