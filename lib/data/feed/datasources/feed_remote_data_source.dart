import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feed_post_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<FeedPostModel>> getFeedPosts({
    required int limit,
    required int offset,
  });

  Future<FeedPostModel> getPostById({required String postId});

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

  Future<FeedPostModel> uploadPost({
    required String userId,
    required String username,
    required String userImage,
    required String postImage,
    required String caption,
  });
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final FirebaseFirestore firestore;

  FeedRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<FeedPostModel>> getFeedPosts({
    required int limit,
    required int offset,
  }) async {
    try {
      final snapshot = await firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit + offset)
          .get();

      final startIndex = offset > snapshot.docs.length ? snapshot.docs.length : offset;
      return snapshot.docs
          .skip(startIndex)
          .take(limit)
          .map((doc) => FeedPostModel.fromJson({
            ...doc.data(),
            'id': doc.id,
          }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get feed posts: $e');
    }
  }

  @override
  Future<FeedPostModel> getPostById({required String postId}) async {
    try {
      final doc = await firestore.collection('posts').doc(postId).get();

      if (!doc.exists) {
        throw Exception('Post not found');
      }

      return FeedPostModel.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      });
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }

  @override
  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  @override
  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('Failed to unlike post: $e');
    }
  }

  @override
  Future<void> commentOnPost({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    try {
      await firestore.collection('posts').doc(postId).collection('comments').add({
        'userId': userId,
        'comment': comment,
        'createdAt': DateTime.now(),
      });

      await firestore.collection('posts').doc(postId).update({
        'comments': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to comment on post: $e');
    }
  }

  @override
  Future<FeedPostModel> uploadPost({
    required String userId,
    required String username,
    required String userImage,
    required String postImage,
    required String caption,
  }) async {
    try {
      final docRef = await firestore.collection('posts').add({
        'userId': userId,
        'username': username,
        'userImage': userImage,
        'postImage': postImage,
        'caption': caption,
        'likes': 0,
        'comments': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'likedBy': [],
      });

      final doc = await docRef.get();
      return FeedPostModel.fromJson({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }
}
