import "package:dio/dio.dart";

import "../../core/logger.dart";
import "api_exception.dart";

ApiException mapDioError(DioException error) {
  final response = error.response;
  final requestPath = error.requestOptions.path;

  // Handle timeout errors
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    AppLogger.networkError("Connection timeout: $requestPath", error: error);
    return ApiException(
      "Connection timed out",
      type: "timeout",
      userMessage: "Internetga ulanish sekin. Iltimos qaytadan urinib ko'ring.",
    );
  }

  // Handle connection errors
  if (error.type == DioExceptionType.connectionError) {
    AppLogger.networkError("No connection: $requestPath", error: error);
    return ApiException(
      "No internet connection",
      type: "connection",
      userMessage: "Internet aloqasi yo'q. Iltimos internetga ulaning.",
    );
  }

  // Handle cancel errors
  if (error.type == DioExceptionType.cancel) {
    AppLogger.debug("Request cancelled: $requestPath");
    return ApiException(
      "Request cancelled",
      type: "cancel",
      userMessage: "So'rov bekor qilindi",
    );
  }

  // Handle response errors
  if (response != null) {
    final statusCode = response.statusCode;
    final data = response.data;

    AppLogger.apiError(
      error.requestOptions.method,
      requestPath,
      statusCode,
      data.toString(),
    );

    // Extract error details
    final message = _extractMessage(data);
    final details = _extractDetails(data);
    final userMessage = _getUserFriendlyMessage(statusCode, message);

    return ApiException(
      message ?? "Request failed",
      statusCode: statusCode,
      type: "http",
      userMessage: userMessage,
      details: details,
    );
  }

  // Unknown error
  AppLogger.error("Unknown error: $requestPath", error: error);
  return ApiException(
    "Unexpected error occurred",
    type: "unknown",
    userMessage:
        "Kutilmagan xatolik yuz berdi. Iltimos qaytadan urinib ko'ring.",
  );
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    // FastAPI validation error format
    if (data.containsKey("detail")) {
      final detail = data["detail"];
      if (detail is String) return detail;
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first.containsKey("msg")) {
          return first["msg"] as String?;
        }
      }
    }

    // Generic message fields
    if (data.containsKey("message")) {
      return data["message"] as String?;
    }
    if (data.containsKey("error")) {
      return data["error"] as String?;
    }
  }
  return null;
}

Map<String, dynamic>? _extractDetails(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data;
  }
  return null;
}

String _getUserFriendlyMessage(int? statusCode, String? technicalMessage) {
  switch (statusCode) {
    case 400:
      return "Noto'g'ri ma'lumot yuborildi. Iltimos qaytadan tekshiring.";
    case 401:
      return "Avtorizatsiya xatosi. Iltimos qaytadan kiring.";
    case 403:
      return "Sizda bu amalni bajarish uchun ruxsat yo'q.";
    case 404:
      return "Ma'lumot topilmadi.";
    case 422:
      return technicalMessage ?? "Ma'lumotlar validatsiyadan o'tmadi.";
    case 429:
      return "Juda ko'p so'rov yuborildi. Iltimos biroz kuting.";
    case 500:
      return "Server xatolik berdi. Iltimos qaytadan urinib ko'ring.";
    case 502:
    case 503:
    case 504:
      return "Server vaqtincha ishlamayapti. Iltimos qaytadan urinib ko'ring.";
    default:
      return technicalMessage ??
          "Xatolik yuz berdi. Iltimos qaytadan urinib ko'ring.";
  }
}
