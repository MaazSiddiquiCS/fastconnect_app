import 'package:dartz/dartz.dart';
import '../../../core/utils/failure.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<Either<Failure, Profile>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}
