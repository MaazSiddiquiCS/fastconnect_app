import 'package:dartz/dartz.dart';
import '../../../core/utils/failure.dart';
import '../../../domain/profile/entities/profile.dart';
import '../../../domain/profile/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Profile>> getProfile(String userId) async {
    try {
      final profileModel = await remoteDataSource.getProfile(userId);
      return Right(profileModel);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure('Failed to fetch profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(Profile profile) async {
    try {
      final profileModel = ProfileModel.fromEntity(profile);
      final updatedProfileModel = await remoteDataSource.updateProfile(profileModel);
      return Right(updatedProfileModel);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure('Failed to update profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(String userId, String filePath) async {
    try {
      final url = await remoteDataSource.uploadProfilePicture(userId, filePath);
      return Right(url);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure('Failed to upload profile picture: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadCoverPhoto(String userId, String filePath) async {
    try {
      final url = await remoteDataSource.uploadCoverPhoto(userId, filePath);
      return Right(url);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure('Failed to upload cover photo: ${e.toString()}'));
    }
  }
}