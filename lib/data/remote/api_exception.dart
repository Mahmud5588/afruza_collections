class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.type});

  final String message;
  final int? statusCode;
  final String? type;

  @override
  String toString() {
    return "ApiException(message: $message, statusCode: $statusCode, type: $type)";
  }
}
