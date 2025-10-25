/// HTTP status codes
class HttpStatusCodes {
  /// OK - 200 success response code
  static const int ok = 200;

  /// Created - 201 success response code
  static const int created = 201;

  /// No Content - 204 success response code
  static const int noContent = 204;

  /// Bad Request - 400 client error code
  static const int badRequest = 400;

  /// Unauthorized - 401 client error code
  static const int unauthorized = 401;

  /// Forbidden - 403 client error code
  static const int forbidden = 403;

  /// Not Found - 404 client error code
  static const int notFound = 404;

  /// Conflict - 409 client error code
  static const int conflict = 409;

  /// Internal Server Error - 500 server error code
  static const int internalServerError = 500;

  /// Not Implemented - 501 server error code
  static const int notImplemented = 501;

  /// Service Unavailable - 503 server error code
  static const int serviceUnavailable = 503;
}

/// Network exception
class NetworkException implements Exception {
  /// Creates a new [NetworkException].
  NetworkException({required this.message, this.statusCode, this.details});

  /// Exception message
  final String message;

  /// HTTP status code
  final int? statusCode;

  /// Exception details
  final String? details;

  @override
  String toString() =>
      'NetworkException: $message${details != null ? ' - $details' : ''}';
}

/// Request timeout exception
class TimeoutException extends NetworkException {
  /// Creates a new [TimeoutException].
  TimeoutException({super.message = 'Request timeout', super.details})
    : super(statusCode: null);
}

/// Connection exception
class ConnectionException extends NetworkException {
  /// Creates a new [ConnectionException].
  ConnectionException({super.message = 'Connection error', super.details})
    : super(statusCode: null);
}

/// Unauthorized exception
class UnauthorizedException extends NetworkException {
  /// Creates a new [UnauthorizedException].
  UnauthorizedException({super.message = 'Unauthorized', super.details})
    : super(statusCode: HttpStatusCodes.unauthorized);
}

/// Server exception
class ServerException extends NetworkException {
  /// Creates a new [ServerException].
  ServerException({
    super.message = 'Server error',
    int? statusCode,
    super.details,
  }) : super(statusCode: statusCode ?? HttpStatusCodes.internalServerError);
}
