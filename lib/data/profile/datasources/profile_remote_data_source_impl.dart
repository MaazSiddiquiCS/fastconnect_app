// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import '../../../core/network/api_client.dart';
// import '../../../core/utils/failure.dart';
// import '../../auth/models/user_model.dart';
// import '../models/profile_model.dart';

// abstract class ProfileRemoteDataSource {
//   Future<ProfileModel> fetchProfile(String userId);
//   Future<ProfileModel> updateProfile(ProfileModel profile);
//   Future<String> uploadProfileImage(String localFilePath, bool isCover);
// }

// class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
//   final ApiClient apiClient;

//   ProfileRemoteDataSourceImpl({required this.apiClient});

//   // Mock implementation for demonstration
//   @override
//   Future<ProfileModel> fetchProfile(String userId) async {
//     // In a real app, you would make an API call:
//     // final response = await apiClient.get('/profile/$userId');
//     // return ProfileModel.fromJson(response);

//     // Mock data based on provided structure
//     await Future.delayed(const Duration(milliseconds: 500));
//     if (userId.isEmpty) {
//       throw Failure('User ID not found');
//     }

//     // Mock data simulating a successful profile fetch
//     final mockJson = {
//       'userId': userId,
//       'fullName': 'Dr. Alex Lee',
//       'tagline': 'Innovating in AI & Robotics',
//       'bio': 'Passionate about leveraging technology to solve complex global challenges. Former intern at Google AI.',
//       'profilePictureUrl': 'https://placehold.co/100x100/A3E4D7/000000?text=AL',
//       'coverPhotoUrl': 'https://placehold.co/600x200/5D6D7E/ffffff?text=Cover+Photo',
//       'location': 'New York, USA',
//       'email': 'alex.lee@university.edu',
//       'connectionsCount': 1245,
//       'postsCount': 87,
//     };

//     return ProfileModel.fromJson(mockJson);
//   }

//   @override
//   Future<ProfileModel> updateProfile(ProfileModel profile) async {
//     // In a real app, you would make an API call:
//     // final response = await apiClient.post('/profile/update', body: profile.toJson());
//     // return ProfileModel.fromJson(response);

//     await Future.delayed(const Duration(milliseconds: 500));

//     // Mock response: return the updated profile
//     if (kDebugMode) {
//       print('Mock: Profile updated on server: ${profile.fullName}');
//     }
//     return profile;
//   }

//   @override
//   Future<String> uploadProfileImage(String localFilePath, bool isCover) async {
//     // In a real app, this would handle file upload to a storage service (e.g., Firebase Storage)
//     await Future.delayed(const Duration(milliseconds: 1000));

//     // Mock response: return a new placeholder URL
//     if (isCover) {
//       return 'https://placehold.co/600x200/F4D03F/000000?text=New+Cover';
//     } else {
//       return 'https://placehold.co/100x100/BB8FCE/000000?text=NEW';
//     }
//   }
// }