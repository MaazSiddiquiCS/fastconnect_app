import 'package:cloud_firestore/cloud_firestore.dart'; // Ye line zaroori hai Timestamp ke liye
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

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    return FeedPostModel(
      // --- NULL SAFETY FIXES (?? '') ---
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? 'Unknown User',
      userImage: json['userImage'] ?? '',
      postImage: json['postImage'] ?? '',
      caption: json['caption'] ?? '',
      
      // --- INT SAFETY FIXES ---
      // Agar null ho to 0, aur agar double ho to int main convert karega
      likes: (json['likes'] ?? 0).toInt(),
      comments: (json['comments'] ?? 0).toInt(),
      
      // --- DATE/TIMESTAMP FIX ---
      createdAt: _parseDate(json['createdAt']),
    );
  }

  // Date handle karne ka alag function taake logic clean rahe
  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    
    // Agar Firestore Timestamp hai (Jo ke hoga)
    if (date is Timestamp) {
      return date.toDate();
    } 
    // Agar String hai
    else if (date is String) {
      return DateTime.tryParse(date) ?? DateTime.now();
    } 
    // Agar pehle se DateTime hai
    else if (date is DateTime) {
      return date;
    }
    
    return DateTime.now();
  }

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