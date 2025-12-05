import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../auth/models/user_model.dart';
import '../../../core/utils/failure.dart';

@immutable
class UserRemoteDataSource {
  final FirebaseFirestore firestore;
  
  UserRemoteDataSource({required this.firestore});

  // Reference to the 'users' collection where rich profiles are stored
  // Set the type explicitly to ensure the map type is known (important for fromFirestore factory)
  CollectionReference<Map<String, dynamic>> get _userCollection => 
    firestore.collection('users').withConverter<Map<String, dynamic>>(
      fromFirestore: (snapshot, _) => snapshot.data()!, 
      toFirestore: (data, _) => data,
    );

  /// Fetches a detailed User profile by their ID (UID) from Firestore
  Future<UserModel> fetchUserById(String userId) async {
    try {
      // Use the typed collection reference
      final doc = await _userCollection.doc(userId).get();

      if (!doc.exists || doc.data() == null) {
        throw Failure('User profile not found in Firestore for ID: $userId');
      }

      // CRITICAL FIX: Use the new factory that correctly extracts the ID from the snapshot
      // and defensively maps the data.
      return UserModel.fromFirestore(doc); 
    } on Failure {
      rethrow;
    } catch (e) {
      // Log the full error to help if the issue is still a missing field
      print('Firestore Read Error: $e'); 
      throw Failure('Failed to fetch user profile from Firestore: Could not map data.');
    }
  }

  /// Creates or updates a detailed User profile in Firestore
  Future<void> saveUser(UserModel userModel) async {
    try {
      // Use the User ID (which should be the Firebase UID) as the document ID
      await _userCollection.doc(userModel.id).set(userModel.toMap());
    } catch (e) {
      throw Failure('Failed to save user profile to Firestore: $e');
    }
  }
}