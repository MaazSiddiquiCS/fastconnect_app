import '../entities/feed_post.dart';
import '../repositories/feed_repository.dart';

class GetPostById {
  final FeedRepository repository;

  GetPostById(this.repository);

  Future<FeedPost> call({required String postId}) async {
    return await repository.getPostById(postId: postId);
  }
}
