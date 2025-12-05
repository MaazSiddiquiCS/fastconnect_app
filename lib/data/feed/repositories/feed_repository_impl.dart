import '../../../domain/feed/entities/feed_post.dart';
import '../../../domain/feed/repositories/feed_repository.dart';
import '../datasources/feed_remote_data_source.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<FeedPost>> getFeedPosts({
    required int limit,
    required int offset,
  }) async {
    try {
      final models = await remoteDataSource.getFeedPosts(
        limit: limit,
        offset: offset,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FeedPost> getPostById({required String postId}) async {
    try {
      final model = await remoteDataSource.getPostById(postId: postId);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.likePost(
        postId: postId,
        userId: userId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await remoteDataSource.unlikePost(
        postId: postId,
        userId: userId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> commentOnPost({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    try {
      await remoteDataSource.commentOnPost(
        postId: postId,
        userId: userId,
        comment: comment,
      );
    } catch (e) {
      rethrow;
    }
  }
}
