import '../repositories/feed_repository.dart';

class UnlikePost {
  final FeedRepository repository;

  UnlikePost(this.repository);

  Future<void> call({
    required String postId,
    required String userId,
  }) async {
    return await repository.unlikePost(postId: postId, userId: userId);
  }
}
