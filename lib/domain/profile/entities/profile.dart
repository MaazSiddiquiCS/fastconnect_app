import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? bio;
  final String? profilePicUrl;
  final String? coverPicUrl;
  final String roleType;
  final bool isFaculty;
  final int? batch;
  final String? rollNumber;
  final String? department;
  final String accountStatus;

  const Profile({
    required this.id,
    required this.fullName,
    required this.email,
    this.bio,
    this.profilePicUrl,
    this.coverPicUrl,
    required this.roleType,
    required this.isFaculty,
    this.batch,
    this.rollNumber,
    this.department,
    required this.accountStatus,
  });

  Profile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? bio,
    String? profilePicUrl,
    String? coverPicUrl,
    String? roleType,
    bool? isFaculty,
    int? batch,
    String? rollNumber,
    String? department,
    String? accountStatus,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      coverPicUrl: coverPicUrl ?? this.coverPicUrl,
      roleType: roleType ?? this.roleType,
      isFaculty: isFaculty ?? this.isFaculty,
      batch: batch ?? this.batch,
      rollNumber: rollNumber ?? this.rollNumber,
      department: department ?? this.department,
      accountStatus: accountStatus ?? this.accountStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        bio,
        profilePicUrl,
        coverPicUrl,
        roleType,
        isFaculty,
        batch,
        rollNumber,
        department,
        accountStatus,
      ];
}