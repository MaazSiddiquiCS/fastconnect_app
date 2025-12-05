import 'user.dart';

// Defines the successful response from login/register use cases
class AuthResult {
  final User user;
  final String accessToken;

  AuthResult({required this.user, required this.accessToken});
}