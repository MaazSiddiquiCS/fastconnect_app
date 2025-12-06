import '../entities/feed_post.dart';
import '../repositories/feed_repository.dart';

class UploadPost {
  final FeedRepository repository;

  UploadPost(this.repository);

  Future<FeedPost> call({
    required String userId,
    required String username,
    required String userImage,
    required String postImage,
    required String caption,
  }) async {
    return await repository.uploadPost(
      userId: userId,
      username: username,
      userImage: userImage,
      postImage: postImage,
      caption: caption,
    );
  }
}
