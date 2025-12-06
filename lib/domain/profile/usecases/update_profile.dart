import 'package:dartz/dartz.dart';
import '../../../core/utils/failure.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, Profile>> call(Profile profile) async {
    return await repository.updateProfile(profile);
  }
}
