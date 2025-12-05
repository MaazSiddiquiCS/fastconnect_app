// domain/auth/usecases/register.dart
import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/user.dart';
import '../entities/auth_result.dart'; // NEW: Import AuthResult
import '../repositories/auth_repository.dart';
// uuid is no longer needed in the use case since the repository handles ID generation
// via Firebase, so I removed the import line.

class Register {
  final AuthRepository repository;

  Register(this.repository);

  // FIX: Change success return type from User to AuthResult
  Future<Either<Failure, AuthResult>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // The repository returns AuthResult which contains User and Token
      final result = await repository.register(
        name: name,
        email: email,
        password: password,
      );
      // Return the full AuthResult object upon success
      return Right(result);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}