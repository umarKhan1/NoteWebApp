import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'exceptions.dart';

/// HTTP client for making API requests
class HttpClient {
  /// Base URL for API
  static const String _baseUrl = 'http://localhost:3000/api';

  /// Timeout duration
  static const Duration _timeout = Duration(seconds: 30);

  /// API key (if needed)
  String? _apiKey;

  /// Authorization token
  String? _token;

  /// HTTP headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_apiKey != null) 'X-API-Key': _apiKey!,
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  /// Sets the API key
  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  /// Sets the authorization token
  void setToken(String token) {
    _token = token;
  }

  /// Clears the authorization token
  void clearToken() {
    _token = null;
  }

  /// GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      
      if (kDebugMode) {
        developer.log('[HTTP] GET $uri', name: 'HttpClient');
      }

      final response = await http.get(
        uri,
        headers: _headers,
      ).timeout(
        _timeout,
        onTimeout: () => throw TimeoutException(
          details: 'GET request to $endpoint timed out',
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    required dynamic body,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final jsonBody = jsonEncode(body);

      if (kDebugMode) {
        developer.log(
          '[HTTP] POST $uri - Body: $jsonBody',
          name: 'HttpClient',
        );
      }

      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonBody,
      ).timeout(
        _timeout,
        onTimeout: () => throw TimeoutException(
          details: 'POST request to $endpoint timed out',
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    required dynamic body,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final jsonBody = jsonEncode(body);

      if (kDebugMode) {
        developer.log(
          '[HTTP] PUT $uri - Body: $jsonBody',
          name: 'HttpClient',
        );
      }

      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonBody,
      ).timeout(
        _timeout,
        onTimeout: () => throw TimeoutException(
          details: 'PUT request to $endpoint timed out',
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');

      if (kDebugMode) {
        developer.log('[HTTP] DELETE $uri', name: 'HttpClient');
      }

      final response = await http.delete(
        uri,
        headers: _headers,
      ).timeout(
        _timeout,
        onTimeout: () => throw TimeoutException(
          details: 'DELETE request to $endpoint timed out',
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Handles response and throws exceptions if needed
  dynamic _handleResponse(http.Response response) {
    if (kDebugMode) {
      developer.log(
        '[HTTP] Status: ${response.statusCode} - Body: ${response.body}',
        name: 'HttpClient',
      );
    }

    if (response.statusCode == HttpStatusCodes.ok ||
        response.statusCode == HttpStatusCodes.created ||
        response.statusCode == HttpStatusCodes.noContent) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    }

    if (response.statusCode == HttpStatusCodes.unauthorized) {
      throw UnauthorizedException(
        message: 'Authentication failed',
        details: response.body,
      );
    }

    if (response.statusCode == HttpStatusCodes.forbidden) {
      throw NetworkException(
        message: 'Access forbidden',
        statusCode: response.statusCode,
        details: response.body,
      );
    }

    if (response.statusCode == HttpStatusCodes.notFound) {
      throw NetworkException(
        message: 'Resource not found',
        statusCode: response.statusCode,
        details: response.body,
      );
    }

    if (response.statusCode == HttpStatusCodes.conflict) {
      throw NetworkException(
        message: 'Conflict',
        statusCode: response.statusCode,
        details: response.body,
      );
    }

    if (response.statusCode >= HttpStatusCodes.internalServerError) {
      throw ServerException(
        message: 'Server error',
        statusCode: response.statusCode,
        details: response.body,
      );
    }

    if (response.statusCode >= HttpStatusCodes.badRequest) {
      throw NetworkException(
        message: 'Request error',
        statusCode: response.statusCode,
        details: response.body,
      );
    }

    throw NetworkException(
      message: 'Unknown error',
      statusCode: response.statusCode,
      details: response.body,
    );
  }

  /// Handles errors
  void _handleError(dynamic error) {
    if (kDebugMode) {
      developer.log(
        '[HTTP] Error: $error',
        name: 'HttpClient',
        error: error,
      );
    }
  }
}
