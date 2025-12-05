import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
class FeedPost extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String userImage;
  final String postImage;
  final String caption;
  final int likes;
  final int comments;
  final DateTime createdAt;

  const FeedPost({
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

  // --- YE FUNCTION ADD KIYA HAI JO ERROR FIX KAREGA ---
  factory FeedPost.fromMap(Map<String, dynamic> map) {
    return FeedPost(
      // ?? '' ka matlab hai agar value null ho to empty string kardo
      id: map['id'] ?? '', 
      userId: map['userId'] ?? '',
      username: map['username'] ?? 'Unknown User',
      
      // Aksar image null hoti hai, isliye yahan check lagaya hai
      userImage: map['userImage'] ?? '', 
      postImage: map['postImage'] ?? '',
      
      // Caption bhi aksar null hota hai
      caption: map['caption'] ?? '', 
      
      // Integers ke liye 0 default value dedi
      likes: map['likes']?.toInt() ?? 0,
      comments: map['comments']?.toInt() ?? 0,
      
      // Date ko safely parse kar rahe hain
      createdAt: map['createdAt'] != null 
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now() 
          : DateTime.now(),
    );
  }
  // ----------------------------------------------------

  FeedPost copyWith({
    String? id,
    String? userId,
    String? username,
    String? userImage,
    String? postImage,
    String? caption,
    int? likes,
    int? comments,
    DateTime? createdAt,
  }) =>
      FeedPost(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        userImage: userImage ?? this.userImage,
        postImage: postImage ?? this.postImage,
        caption: caption ?? this.caption,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [
        id,
        userId,
        username,
        userImage,
        postImage,
        caption,
        likes,
        comments,
        createdAt,
      ];
}