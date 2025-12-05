import '../../../domain/feed/entities/feed_post.dart';

class FeedPostModel {
  final String id;
  final String userId;
  final String username;
  final String userImage;
  final String postImage;
  final String caption;
  final int likes;
  final int comments;
  final DateTime createdAt;

  FeedPostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) => FeedPostModel(
    id: json['id'] as String,
    userId: json['userId'] as String,
    username: json['username'] as String,
    userImage: json['userImage'] as String,
    postImage: json['postImage'] as String,
    caption: json['caption'] as String,
    likes: json['likes'] as int? ?? 0,
    comments: json['comments'] as int? ?? 0,
    createdAt: json['createdAt'] is DateTime
        ? json['createdAt'] as DateTime
        : DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'username': username,
    'userImage': userImage,
    'postImage': postImage,
    'caption': caption,
    'likes': likes,
    'comments': comments,
    'createdAt': createdAt.toIso8601String(),
  };

  FeedPost toEntity() => FeedPost(
    id: id,
    userId: userId,
    username: username,
    userImage: userImage,
    postImage: postImage,
    caption: caption,
    likes: likes,
    comments: comments,
    createdAt: createdAt,
  );

  factory FeedPostModel.fromEntity(FeedPost feedPost) => FeedPostModel(
    id: feedPost.id,
    userId: feedPost.userId,
    username: feedPost.username,
    userImage: feedPost.userImage,
    postImage: feedPost.postImage,
    caption: feedPost.caption,
    likes: feedPost.likes,
    comments: feedPost.comments,
    createdAt: feedPost.createdAt,
  );
}
