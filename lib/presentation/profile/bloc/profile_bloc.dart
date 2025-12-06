import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/profile/usecases/get_profile.dart';
import '../../../domain/profile/usecases/update_profile.dart';
import '../../../domain/profile/usecases/upload_profile_picture.dart';
import '../../../domain/profile/usecases/upload_cover_photo.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;
  final UploadProfilePicture uploadProfilePictureUseCase;
  final UploadCoverPhoto uploadCoverPhotoUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadProfilePictureUseCase,
    required this.uploadCoverPhotoUseCase,
  }) : super(const ProfileInitial()) {
    on<GetProfileDetails>(_onGetProfileDetails);
    on<UpdateProfileDetails>(_onUpdateProfileDetails);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
    on<UploadCoverPhotoEvent>(_onUploadCoverPhoto);
  }

  Future<void> _onGetProfileDetails(
    GetProfileDetails event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await getProfileUseCase(event.userId);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfileDetails(
    UpdateProfileDetails event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await updateProfileUseCase(event.profile);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) {
        if (kDebugMode) print('Profile updated: ${profile.fullName}');
        emit(ProfileUpdateSuccess(profile));
      },
    );
  }

  Future<void> _onUploadProfilePicture(
    UploadProfilePictureEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await uploadProfilePictureUseCase(event.userId, event.filePath);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (url) => emit(UploadSuccess(url: url, type: 'profile')),
    );
  }

  Future<void> _onUploadCoverPhoto(
    UploadCoverPhotoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await uploadCoverPhotoUseCase(event.userId, event.filePath);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (url) => emit(UploadSuccess(url: url, type: 'cover')),
    );
  }
}
