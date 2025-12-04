import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/failure.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;
  
  ApiClient({required this.baseUrl}) : client = http.Client();


  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final uri = Uri.parse("$baseUrl$path");

    try {
      final response = await client
          .get(uri, headers: headers)
          .timeout(AppConstants.networkTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Failure("Network error: $e");
    }
  }

  Future<dynamic> post(String path,
      {Map<String, String>? headers, Object? body}) async {
    final uri = Uri.parse("$baseUrl$path");

    try {
      final response = await client
          .post(uri, headers: headers, body: body)
          .timeout(AppConstants.networkTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw Failure("Network error: $e");
    }
  }

  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    throw Failure(
      "Request failed",
      code: status,
    );
  }
}