import '../repositories/feed_repository.dart';

class CommentOnPost {
  final FeedRepository repository;

  CommentOnPost(this.repository);

  Future<void> call({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    return await repository.commentOnPost(
      postId: postId,
      userId: userId,
      comment: comment,
    );
  }
}
