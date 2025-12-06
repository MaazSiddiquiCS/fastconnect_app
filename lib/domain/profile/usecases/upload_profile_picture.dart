import 'package:dartz/dartz.dart';
import '../../../core/utils/failure.dart';
import '../repositories/profile_repository.dart';

class UploadProfilePicture {
  final ProfileRepository repository;

  UploadProfilePicture(this.repository);

  Future<Either<Failure, String>> call(String userId, String filePath) async {
    return await repository.uploadProfilePicture(userId, filePath);
  }
}
