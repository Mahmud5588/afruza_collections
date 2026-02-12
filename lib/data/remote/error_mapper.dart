import "package:dio/dio.dart";

import "api_exception.dart";

ApiException mapDioError(DioException error) {
  final response = error.response;
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return ApiException("Connection timed out. Please try again.",
        type: "timeout");
  }

  if (error.type == DioExceptionType.connectionError) {
    return ApiException("No internet connection.", type: "connection");
  }

  if (response != null) {
    final statusCode = response.statusCode;
    final data = response.data;
    final message = _extractMessage(data) ??
        (statusCode != null
            ? "Request failed ($statusCode)."
            : "Request failed.");
    return ApiException(message, statusCode: statusCode, type: "http");
  }

  return ApiException("Unexpected error. Please try again.", type: "unknown");
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    final detail = data["detail"];
    if (detail is String && detail.isNotEmpty) {
      return detail;
    }
    final message = data["message"];
    if (message is String && message.isNotEmpty) {
      return message;
    }
    final error = data["error"];
    if (error is String && error.isNotEmpty) {
      return error;
    }
  }
  return null;
}
