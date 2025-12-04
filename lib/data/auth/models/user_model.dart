// data/models/user_model.dart

import '../../../domain/auth/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String name,
    required String email,
    required String token,
    String? rollNumber,
    String? avatarUrl,
  }) : super(
          id: id,
          name: name,
          email: email,
          token: token,
          rollNumber: "",
          avatarUrl: avatarUrl,
        );

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      rollNumber: map['rollNumber'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'rollNumber': rollNumber,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      token: user.token,
      rollNumber: user.rollNumber,
      avatarUrl: user.avatarUrl,
    );
  }
}