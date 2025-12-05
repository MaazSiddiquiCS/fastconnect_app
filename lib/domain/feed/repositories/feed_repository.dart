import '../entities/feed_post.dart';

abstract class FeedRepository {
  Future<List<FeedPost>> getFeedPosts({
    required int limit,
    required int offset,
  });

  Future<FeedPost> getPostById({required String postId});

  Future<void> likePost({
    required String postId,
    required String userId,
  });

  Future<void> unlikePost({
    required String postId,
    required String userId,
  });

  Future<void> commentOnPost({
    required String postId,
    required String userId,
    required String comment,
  });
}
