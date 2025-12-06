import '../repositories/feed_repository.dart';

class LikePost {
  final FeedRepository repository;

  LikePost(this.repository);

  Future<void> call({
    required String postId,
    required String userId,
  }) async {
    return await repository.likePost(postId: postId, userId: userId);
  }
}
