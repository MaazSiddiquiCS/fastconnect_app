import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/profile_model.dart';
import '../../../core/utils/failure.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<String> uploadProfilePicture(String userId, String filePath);
  Future<String> uploadCoverPhoto(String userId, String filePath);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileRemoteDataSourceImpl({required this.firestore, required this.storage});

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Failure('Profile not found');
      }
      final data = doc.data() ?? {};
      data['id'] = userId;
      return ProfileModel.fromFirestore(data);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      await firestore.collection('users').doc(profile.id).update(profile.toFirestore());
      return profile;
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<String> uploadProfilePicture(String userId, String filePath) async {
    try {
      final file = File(filePath);
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = storage.ref().child('profiles/$userId/$fileName');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      
      await firestore.collection('users').doc(userId).update({'profilePicUrl': url});
      
      return url;
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<String> uploadCoverPhoto(String userId, String filePath) async {
    try {
      final file = File(filePath);
      final fileName = 'cover_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = storage.ref().child('profiles/$userId/$fileName');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      
      await firestore.collection('users').doc(userId).update({'coverPicUrl': url});
      
      return url;
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}