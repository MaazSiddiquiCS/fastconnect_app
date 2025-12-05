import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';
import '../../../core/network/api_client.dart';
import 'user_remote_data_source.dart';
import '../models/user_model.dart';
import '../../../core/utils/failure.dart';
import 'package:flutter/foundation.dart'; // Added for debugPrint

// Helper class defined in previous steps
class AuthResponse {
  final UserModel user;
  final String accessToken;
  AuthResponse({required this.user, required this.accessToken});
}

class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth auth;
  final UserRemoteDataSource userDataSource;
  final ApiClient apiClient;

  AuthRemoteDataSource({
    required this.auth,
    required this.userDataSource,
    required this.apiClient,
  });

  /// Helper method to translate Firebase Auth exceptions into user-friendly messages
  String _translateFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Login failed: No user found for this email address.';
      case 'wrong-password':
        return 'Login failed: Incorrect password.';
      case 'invalid-email':
        return 'Login failed: The email address format is invalid.';
      case 'user-disabled':
        return 'Login failed: Your account has been disabled.';
      case 'too-many-requests':
        return 'Login failed: Too many failed attempts. Please try again later.';
      default:
        // Use a generic message for unhandled Firebase exceptions
        return 'Login failed: An unexpected authentication error occurred.';
    }
  }

  /// Login using Firebase Authentication
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Failure('Login failed: Invalid credentials.');

      // 1. Get the Firebase ID Token
      final token = await firebaseUser.getIdToken();
      if (token == null) throw Failure('Failed to retrieve access token.');

      // 2. Fetch the rich user profile from Firestore
      final userModel = await userDataSource.fetchUserById(firebaseUser.uid);

      return AuthResponse(user: userModel, accessToken: token);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Map Firebase specific errors
      final userMessage = _translateFirebaseAuthError(e.code);
      throw Failure(userMessage, code: int.tryParse(e.code) ?? 401);
    } catch (e) {
      // FIX: Print the underlying error to the console for debugging
      debugPrint('CRITICAL LOGIN ERROR: $e');

      if (e is Failure) rethrow; 
      // More specific failure message for the user:
      throw Failure('Login failed: Authentication succeeded, but we could not load your profile data.');
    }
  }

  /// Register using Firebase Authentication and save rich profile to Firestore
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Failure('Registration failed.');

      // 1. Create a minimal UserModel based on the new Firebase user
      final newUserModel = UserModel(
        id: firebaseUser.uid,
        email: email.trim(),
        fullName: name.trim(),
        rollNumber: '', 
        roleType: 'STUDENT',
        accountStatus: 'ACTIVE',
        department: '',
        batch: DateTime.now().year,
        isFaculty: false,
        profilePic: null,
        coverPic: null,
        bio: 'Hello, I am a new user!',
      );

      // 2. Save the rich profile to Firestore
      await userDataSource.saveUser(newUserModel);

      // 3. Get the Firebase ID Token
      final token = await firebaseUser.getIdToken();
      if (token == null) throw Failure('Failed to retrieve access token.');

      return AuthResponse(user: newUserModel, accessToken: token);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Map Firebase specific errors
      final userMessage = _translateFirebaseAuthError(e.code);
      throw Failure(userMessage, code: int.tryParse(e.code) ?? 409);
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure('Failed to register: Could not save profile data.');
    }
  }

  /// Logout (Signs out of Firebase Auth)
  Future<void> logout({required String token}) async {
    await auth.signOut(); 
  }

  /// Get current user profile (Uses the currently signed-in Firebase user)
  Future<UserModel> getProfile({required String token}) async {
    try {
      final firebaseUser = auth.currentUser;

      if (firebaseUser == null) throw Failure('No user is currently signed in.');
      
      // Fetch the rich user profile from Firestore using the Firebase UID
      return await userDataSource.fetchUserById(firebaseUser.uid);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Failed to fetch profile: $e');
    }
  }
}