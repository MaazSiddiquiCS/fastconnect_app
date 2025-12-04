import 'package:meta/meta.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String rollNumber;
  final String token;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.token,
    this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? rollNumber,
    String? token,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      rollNumber: rollNumber ?? this.rollNumber,
      token: token ?? this.token,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
