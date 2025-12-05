import '../../../domain/auth/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

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

  // Factory for Firestore (doc.id used for 'id')
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    if (data == null) {
      throw StateError('Cannot create UserModel from null data');
    }

    return UserModel(
      id: doc.id,
      email: (data['email'] as String?) ?? '',
      fullName: (data['fullName'] as String?) ?? 'N/A', 
      rollNumber: (data['rollNumber'] as String?) ?? '',
      roleType: (data['roleType'] as String?) ?? 'STUDENT',
      accountStatus: (data['accountStatus'] as String?) ?? 'ACTIVE',
      department: (data['department'] as String?) ?? '',
      batch: data['batch'] is int ? data['batch'] as int : DateTime.now().year,
      isFaculty: data['isFaculty'] is bool ? data['isFaculty'] as bool : false,
      bio: data['bio'] as String?,
      profilePic: data['profilePic'] as String?,
      coverPic: data['coverPic'] as String?,
    );
  }
  
  // NEW FACTORY: For Local Storage (JSON)
  factory UserModel.fromLocalMap(Map<String, dynamic> map) {
    final data = map;

    return UserModel(
      // CRITICAL FIX: Expect 'id' to be present in the map for local retrieval
      id: (data['id'] as String?) ?? '', 
      email: (data['email'] as String?) ?? '',
      fullName: (data['fullName'] as String?) ?? 'N/A', 
      rollNumber: (data['rollNumber'] as String?) ?? '',
      roleType: (data['roleType'] as String?) ?? 'STUDENT',
      accountStatus: (data['accountStatus'] as String?) ?? 'ACTIVE',
      department: (data['department'] as String?) ?? '',

      batch: data['batch'] is int ? data['batch'] as int : DateTime.now().year,
      isFaculty: data['isFaculty'] is bool ? data['isFaculty'] as bool : false,

      bio: data['bio'] as String?,
      profilePic: data['profilePic'] as String?,
      coverPic: data['coverPic'] as String?,
    );
  }


  // Method to convert UserModel to a Map for Local Storage (INCLUDES ID)
  // This is the method used by AuthLocalDataSource.cacheUser
  @override
  Map<String, dynamic> toMap() {
    return {
      // FIX: Include 'id' for local storage (essential for model reconstruction)
      'id': id, 
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
  
  // Method to convert UserModel to a Map for Firestore (EXCLUDES ID)
  // If you use this for Firestore sets, the document ID is the key
  Map<String, dynamic> toFirestoreMap() {
    return {
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