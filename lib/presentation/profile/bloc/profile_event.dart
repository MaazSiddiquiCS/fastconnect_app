import 'package:equatable/equatable.dart';
import '../../../../domain/profile/entities/profile.dart';
import 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileDetails extends ProfileEvent {
  final String userId;

  const GetProfileDetails({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileDetails extends ProfileEvent {
  final Profile profile;

  const UpdateProfileDetails({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class UploadProfilePictureEvent extends ProfileEvent {
  final String userId;
  final String filePath;

  const UploadProfilePictureEvent({required this.userId, required this.filePath});

  @override
  List<Object?> get props => [userId, filePath];
}

class UploadCoverPhotoEvent extends ProfileEvent {
  final String userId;
  final String filePath;

  const UploadCoverPhotoEvent({required this.userId, required this.filePath});

  @override
  List<Object?> get props => [userId, filePath];
}
