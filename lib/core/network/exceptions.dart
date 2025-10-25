/// HTTP status codes
class HttpStatusCodes {
  /// Success response codes
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;

  /// Client error codes
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;

  /// Server error codes
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int serviceUnavailable = 503;
}

/// Network exception
class NetworkException implements Exception {
  /// Exception message
  final String message;

  /// HTTP status code
  final int? statusCode;

  /// Exception details
  final String? details;

  /// Creates a new [NetworkException].
  NetworkException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() => 'NetworkException: $message${details != null ? ' - $details' : ''}';
}

/// Request timeout exception
class TimeoutException extends NetworkException {
  /// Creates a new [TimeoutException].
  TimeoutException({
    String message = 'Request timeout',
    String? details,
  }) : super(
    message: message,
    statusCode: null,
    details: details,
  );
}

/// Connection exception
class ConnectionException extends NetworkException {
  /// Creates a new [ConnectionException].
  ConnectionException({
    String message = 'Connection error',
    String? details,
  }) : super(
    message: message,
    statusCode: null,
    details: details,
  );
}

/// Unauthorized exception
class UnauthorizedException extends NetworkException {
  /// Creates a new [UnauthorizedException].
  UnauthorizedException({
    String message = 'Unauthorized',
    String? details,
  }) : super(
    message: message,
    statusCode: HttpStatusCodes.unauthorized,
    details: details,
  );
}

/// Server exception
class ServerException extends NetworkException {
  /// Creates a new [ServerException].
  ServerException({
    String message = 'Server error',
    int? statusCode,
    String? details,
  }) : super(
    message: message,
    statusCode: statusCode ?? HttpStatusCodes.internalServerError,
    details: details,
  );
}
