import 'package:equatable/equatable.dart';
import '../../../domain/reels/entities/reel.dart';

abstract class ReelsState extends Equatable {
  const ReelsState();
  @override
  List<Object?> get props => [];
}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<Reel> reels;
  final Set<int> likedIds;
  final int page;

  const ReelsLoaded({required this.reels, required this.likedIds, this.page = 1});
  @override
  List<Object?> get props => [reels, likedIds, page];
}

class ReelsError extends ReelsState {
  final String message;
  const ReelsError(this.message);
  @override
  List<Object?> get props => [message];
}
