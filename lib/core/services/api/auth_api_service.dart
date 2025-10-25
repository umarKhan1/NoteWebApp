import '../../network/http_client.dart';

/// API service for authentication operations
class AuthApiService {
  /// HTTP client instance
  final HttpClient _httpClient;

  /// Creates a new [AuthApiService].
  AuthApiService(this._httpClient);

  /// Endpoint for authentication
  static const String _endpoint = '/auth';

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post(
        '$_endpoint/login',
        body: {
          'email': email,
          'password': password,
        },
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Register user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _httpClient.post(
        '$_endpoint/register',
        body: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _httpClient.post('$_endpoint/logout', body: {});
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh token
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final response = await _httpClient.post(
        '$_endpoint/refresh',
        body: {},
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _httpClient.get('$_endpoint/me');
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
