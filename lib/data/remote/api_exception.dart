class ApiException implements Exception {
  ApiException(
    this.message, {
    this.statusCode,
    this.type,
    this.userMessage,
    this.details,
  });

  final String message; // Technical message
  final String? userMessage; // User-friendly message
  final int? statusCode;
  final String? type;
  final Map<String, dynamic>? details;

  /// Get user-friendly message
  String get displayMessage => userMessage ?? message;

  /// Check if error is network-related
  bool get isNetworkError => type == "connection" || type == "timeout";

  /// Check if error is authentication-related
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  /// Check if error is validation-related
  bool get isValidationError => statusCode == 422;

  /// Check if error is server-related
  bool get isServerError => statusCode != null && statusCode! >= 500;

  @override
  String toString() {
    return "ApiException(message: $message, statusCode: $statusCode, type: $type)";
  }
}
