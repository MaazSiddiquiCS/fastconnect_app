import '../../../domain/auth/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for DocumentSnapshot

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    required String fullName,
    required String rollNumber,
    required String roleType,
    required String accountStatus,
    required String department,
    required int batch,
    required bool isFaculty,
    String? bio,
    String? profilePic,
    String? coverPic,
  }) : super(
          id: id,
          email: email,
          fullName: fullName,
          rollNumber: rollNumber,
          roleType: roleType,
          accountStatus: accountStatus,
          department: department,
          batch: batch,
          isFaculty: isFaculty,
          bio: bio,
          profilePic: profilePic,
          coverPic: coverPic,
        );

  // --- NEW FACTORY: Explicitly handles Firestore DocumentSnapshot ---
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    if (data == null) {
      throw StateError('Cannot create UserModel from null data');
    }

    // Defensive mapping for all non-nullable fields
    return UserModel(
      // CRITICAL FIX: Use the document's ID as the user's ID
      id: doc.id,
      email: (data['email'] as String?) ?? '',
      fullName: (data['fullName'] as String?) ?? 'N/A', 
      rollNumber: (data['rollNumber'] as String?) ?? '',
      roleType: (data['roleType'] as String?) ?? 'STUDENT',
      accountStatus: (data['accountStatus'] as String?) ?? 'ACTIVE',
      department: (data['department'] as String?) ?? '',

      // Non-nullable Primitives
      batch: data['batch'] is int ? data['batch'] as int : DateTime.now().year,
      isFaculty: data['isFaculty'] is bool ? data['isFaculty'] as bool : false,

      // Nullable Strings
      bio: data['bio'] as String?,
      profilePic: data['profilePic'] as String?,
      coverPic: data['coverPic'] as String?,
    );
  }

  // NOTE: Original fromMap is removed or replaced by fromFirestore if only used for DB reads.
  // For a clean separation, we will focus only on the toMap and fromEntity here:

  // Method to convert UserModel to a Map for Firestore storage or API request body (if needed)
  Map<String, dynamic> toMap() {
    return {
      // NOTE: 'id' is correctly excluded as it's the document key in Firestore
      'email': email,
      'fullName': fullName,
      'rollNumber': rollNumber,
      'roleType': roleType,
      'accountStatus': accountStatus,
      'department': department,
      'batch': batch,
      'isFaculty': isFaculty,
      if (bio != null) 'bio': bio,
      if (profilePic != null) 'profilePic': profilePic,
      if (coverPic != null) 'coverPic': coverPic,
    };
  }

  // Factory to convert a domain Entity to a Model (for saving)
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      rollNumber: user.rollNumber,
      roleType: user.roleType,
      accountStatus: user.accountStatus,
      department: user.department,
      batch: user.batch,
      isFaculty: user.isFaculty,
      bio: user.bio,
      profilePic: user.profilePic,
      coverPic: user.coverPic,
    );
  }
}