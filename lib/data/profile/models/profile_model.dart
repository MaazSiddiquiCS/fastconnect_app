import '../../../domain/profile/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required String id,
    required String fullName,
    required String email,
    String? bio,
    String? profilePicUrl,
    String? coverPicUrl,
    required String roleType,
    required bool isFaculty,
    int? batch,
    String? rollNumber,
    String? department,
    required String accountStatus,
  }) : super(
          id: id,
          fullName: fullName,
          email: email,
          bio: bio,
          profilePicUrl: profilePicUrl,
          coverPicUrl: coverPicUrl,
          roleType: roleType,
          isFaculty: isFaculty,
          batch: batch,
          rollNumber: rollNumber,
          department: department,
          accountStatus: accountStatus,
        );

  factory ProfileModel.fromFirestore(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'],
      profilePicUrl: json['profilePicUrl'],
      coverPicUrl: json['coverPicUrl'],
      roleType: json['roleType'] ?? 'STUDENT',
      isFaculty: json['isFaculty'] ?? false,
      batch: json['batch'],
      rollNumber: json['rollNumber'],
      department: json['department'],
      accountStatus: json['accountStatus'] ?? 'ACTIVE',
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      fullName: profile.fullName,
      email: profile.email,
      bio: profile.bio,
      profilePicUrl: profile.profilePicUrl,
      coverPicUrl: profile.coverPicUrl,
      roleType: profile.roleType,
      isFaculty: profile.isFaculty,
      batch: profile.batch,
      rollNumber: profile.rollNumber,
      department: profile.department,
      accountStatus: profile.accountStatus,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'bio': bio ?? '',
      'profilePicUrl': profilePicUrl ?? '',
      'coverPicUrl': coverPicUrl ?? '',
      'roleType': roleType,
      'isFaculty': isFaculty,
      'batch': batch,
      'rollNumber': rollNumber ?? '',
      'department': department ?? '',
      'accountStatus': accountStatus,
    };
  }
}