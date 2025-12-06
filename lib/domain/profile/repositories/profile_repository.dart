import 'package:dartz/dartz.dart';
import '../../../core/utils/failure.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String userId);
  Future<Either<Failure, Profile>> updateProfile(Profile profile);
  Future<Either<Failure, String>> uploadProfilePicture(String userId, String filePath);
  Future<Either<Failure, String>> uploadCoverPhoto(String userId, String filePath);
}