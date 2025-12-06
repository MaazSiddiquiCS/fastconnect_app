import 'package:dartz/dartz.dart';
import '../../../core/utils/failure.dart';
import '../repositories/profile_repository.dart';

class UploadCoverPhoto {
  final ProfileRepository repository;

  UploadCoverPhoto(this.repository);

  Future<Either<Failure, String>> call(String userId, String filePath) async {
    return await repository.uploadCoverPhoto(userId, filePath);
  }
}
