// import 'dart:async';
// import '../../../core/utils/failure.dart';
// import '../../auth/models/user_model.dart';

// class AuthMockDataSource {
//   // Simulate network latency
//   Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

//   Future<UserModel> login({
//     required String email,
//     required String password,
//   }) async {
//     await _delay();

//     // Basic mock validation
//     if (email.contains('@fast.edu.pk') || email.contains('@fast.edu')) {
//       // return mock user
//       return UserModel(
//         id: 'u_1001',
//         name: 'Maaz Siddiqui',
//         email: email,
//         rollNumber: '22K-5116',
//         token: 'mock-jwt-token-12345',
//         avatarUrl: null,
//       );
//     }

//     throw Failure('Invalid FAST email in mock login');
//   }

//   Future<void> logout({required String token}) async {
//     await _delay();
//     // no-op for mock
//   }

//   Future<UserModel> getProfile({required String token}) async {
//     await _delay();

//     if (token.startsWith('mock')) {
//       return UserModel(
//         id: 'u_1001',
//         name: 'Maaz Siddiqui',
//         email: 'maaz@fast.edu.pk',
//         rollNumber: '22K-5116',
//         token: token,
//         avatarUrl: null,
//       );
//     }

//     throw Failure('Invalid mock token');
//   }
// }
