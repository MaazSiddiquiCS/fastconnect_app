import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FetchFeedPosts extends FeedEvent {
  final int limit;
  final int offset;

  const FetchFeedPosts({required this.limit, required this.offset});

  @override
  List<Object> get props => [limit, offset];
}

class LikePostEvent extends FeedEvent {
  final String postId;
  final String userId;

  const LikePostEvent({required this.postId, required this.userId});

  @override
  List<Object> get props => [postId, userId];
}

class UnlikePostEvent extends FeedEvent {
  final String postId;
  final String userId;

  const UnlikePostEvent({required this.postId, required this.userId});

  @override
  List<Object> get props => [postId, userId];
}

class CommentPostEvent extends FeedEvent {
  final String postId;
  final String userId;
  final String comment;

  const CommentPostEvent({
    required this.postId,
    required this.userId,
    required this.comment,
  });

  @override
  List<Object> get props => [postId, userId, comment];
}

class RefreshFeed extends FeedEvent {
  const RefreshFeed();
}

class UploadPostEvent extends FeedEvent {
  final String userId;
  final String username;
  final String userImage;
  final String postImage;
  final String caption;

  const UploadPostEvent({
    required this.userId,
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
  });

  @override
  List<Object> get props => [userId, username, userImage, postImage, caption];
}
