import 'package:equatable/equatable.dart';
import '../../../domain/feed/entities/feed_post.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final List<FeedPost> posts;
  final bool hasReachedMax;

  const FeedLoaded({
    required this.posts,
    required this.hasReachedMax,
  });

  FeedLoaded copyWith({
    List<FeedPost>? posts,
    bool? hasReachedMax,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax];
}

class FeedError extends FeedState {
  final String message;

  const FeedError({required this.message});

  @override
  List<Object> get props => [message];
}
