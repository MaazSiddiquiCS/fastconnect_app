import '../entities/feed_post.dart';
import '../repositories/feed_repository.dart';

class GetFeedPosts {
  final FeedRepository repository;

  GetFeedPosts(this.repository);

  Future<List<FeedPost>> call({
    required int limit,
    required int offset,
  }) async {
    return await repository.getFeedPosts(limit: limit, offset: offset);
  }
}
