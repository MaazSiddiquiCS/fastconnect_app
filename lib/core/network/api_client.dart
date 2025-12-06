import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/failure.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required this.baseUrl,
    required this.client,
    Map<String, String>? defaultHeaders,
  }) : defaultHeaders = defaultHeaders ?? {
          'Authorization': AppConstants.pexelsApiKey,
          'Accept': 'application/json',
        };

  Future<dynamic> get(String path, {Map<String, String>? params, Map<String, String>? headers}) async {
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: params);
    final merged = {...defaultHeaders, if (headers != null) ...headers};

    try {
      final response = await client.get(uri, headers: merged).timeout(AppConstants.networkTimeout);
      return _handleResponse(response);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    String msg = 'Request failed';
    try {
      final decoded = jsonDecode(response.body);
      msg = decoded['error'] ?? decoded['message'] ?? msg;
    } catch (_) {}
    throw Failure(msg, code: status);
  }
}
