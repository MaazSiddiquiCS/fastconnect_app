import 'package:equatable/equatable.dart';
import '../../../../domain/profile/entities/profile.dart';

import 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateSuccess extends ProfileState {
  final Profile profile;

  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UploadSuccess extends ProfileState {
  final String url;
  final String type; // 'profile' or 'cover'

  const UploadSuccess({required this.url, required this.type});

  @override
  List<Object?> get props => [url, type];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
