import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/feed/usecases/get_feed_posts.dart';
import '../../../domain/feed/usecases/like_post.dart';
import '../../../domain/feed/usecases/unlike_post.dart';
import '../../../domain/feed/usecases/comment_on_post.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFeedPosts getFeedPosts;
  final LikePost likePost;
  final UnlikePost unlikePost;
  final CommentOnPost commentOnPost;

  static const int _pageSize = 10;

  FeedBloc({
    required this.getFeedPosts,
    required this.likePost,
    required this.unlikePost,
    required this.commentOnPost,
  }) : super(const FeedInitial()) {
    on<FetchFeedPosts>(_onFetchFeedPosts);
    on<LikePostEvent>(_onLikePost);
    on<UnlikePostEvent>(_onUnlikePost);
    on<CommentPostEvent>(_onCommentPost);
    on<RefreshFeed>(_onRefreshFeed);
  }

  Future<void> _onFetchFeedPosts(
    FetchFeedPosts event,
    Emitter<FeedState> emit,
  ) async {
    try {
      emit(const FeedLoading());
      final posts = await getFeedPosts(
        limit: event.limit,
        offset: event.offset,
      );

      emit(FeedLoaded(
        posts: posts,
        hasReachedMax: posts.length < _pageSize,
      ));
    } catch (e) {
      emit(FeedError(message: e.toString()));
    }
  }

  Future<void> _onLikePost(
    LikePostEvent likePostEvent,
    Emitter<FeedState> emit,
  ) async {
    if (state is FeedLoaded) {
      try {
        await likePost(postId: likePostEvent.postId, userId: likePostEvent.userId);
      } catch (e) {
        emit(FeedError(message: e.toString()));
      }
    }
  }

  Future<void> _onUnlikePost(
    UnlikePostEvent unlikePostEvent,
    Emitter<FeedState> emit,
  ) async {
    if (state is FeedLoaded) {
      try {
        await unlikePost(postId: unlikePostEvent.postId, userId: unlikePostEvent.userId);
      } catch (e) {
        emit(FeedError(message: e.toString()));
      }
    }
  }

  Future<void> _onCommentPost(
    CommentPostEvent event,
    Emitter<FeedState> emit,
  ) async {
    if (state is FeedLoaded) {
      try {
        await commentOnPost(
          postId: event.postId,
          userId: event.userId,
          comment: event.comment,
        );
      } catch (e) {
        emit(FeedError(message: e.toString()));
      }
    }
  }

  Future<void> _onRefreshFeed(
    RefreshFeed event,
    Emitter<FeedState> emit,
  ) async {
    try {
      emit(const FeedLoading());
      final posts = await getFeedPosts(limit: _pageSize, offset: 0);
      emit(FeedLoaded(
        posts: posts,
        hasReachedMax: posts.length < _pageSize,
      ));
    } catch (e) {
      emit(FeedError(message: e.toString()));
    }
  }
}
