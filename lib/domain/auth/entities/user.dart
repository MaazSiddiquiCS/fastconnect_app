import 'package:meta/meta.dart';

@immutable
class User {
  // Corresponds to the document ID (e.g., "user_id_john")
  final String id; 
  final String email;
  final String fullName; // Maps to 'fullName'
  final String rollNumber; // Maps to 'rollNumber'
  final String roleType; // Maps to 'roleType'
  final String accountStatus; // Maps to 'accountStatus'
  final String department; // Maps to 'department'
  final int batch; // Maps to 'batch'
  final bool isFaculty; // Maps to 'isFaculty'
  final String? bio; // Maps to 'bio'
  final String? profilePic; // Maps to 'profilePic'
  final String? coverPic; // Maps to 'coverPic'

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.rollNumber,
    required this.roleType,
    required this.accountStatus,
    required this.department,
    required this.batch,
    required this.isFaculty,
    this.bio,
    this.profilePic,
    this.coverPic,
  });

  // copyWith method remains the same for the updated properties
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? rollNumber,
    String? roleType,
    String? accountStatus,
    String? department,
    int? batch,
    bool? isFaculty,
    String? bio,
    String? profilePic,
    String? coverPic,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      rollNumber: rollNumber ?? this.rollNumber,
      roleType: roleType ?? this.roleType,
      accountStatus: accountStatus ?? this.accountStatus,
      department: department ?? this.department,
      batch: batch ?? this.batch,
      isFaculty: isFaculty ?? this.isFaculty,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      coverPic: coverPic ?? this.coverPic,
    );
  }
}