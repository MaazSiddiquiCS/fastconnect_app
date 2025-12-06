import 'package:equatable/equatable.dart';

abstract class ReelsEvent extends Equatable {
  const ReelsEvent();
  @override
  List<Object?> get props => [];
}

class LoadPopularReels extends ReelsEvent {
  final int page;
  const LoadPopularReels({this.page = 1});
  @override
  List<Object?> get props => [page];
}

class ToggleLikeReel extends ReelsEvent {
  final int reelId;
  const ToggleLikeReel(this.reelId);
  @override
  List<Object?> get props => [reelId];
}
