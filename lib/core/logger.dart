import "dart:developer" as developer;
import "package:flutter/foundation.dart";

/// Professional logging system with different log levels
class AppLogger {
  static const String _tag = "AfruzaApp";

  /// Log info messages - normal operations
  static void info(String message, {String? tag}) {
    _log("ℹ️ INFO", tag ?? _tag, message);
  }

  /// Log debug messages - detailed information for debugging
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      _log("🐛 DEBUG", tag ?? _tag, message);
    }
  }

  /// Log warning messages - potential issues
  static void warning(String message, {String? tag}) {
    _log("⚠️ WARNING", tag ?? _tag, message);
  }

  /// Log error messages with optional error object and stack trace
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final errorMsg = StringBuffer(message);
    if (error != null) {
      errorMsg.write("\nError: $error");
    }
    if (stackTrace != null && kDebugMode) {
      errorMsg.write("\nStackTrace: $stackTrace");
    }
    _log("❌ ERROR", tag ?? _tag, errorMsg.toString());
  }

  /// Log API requests
  static void apiRequest(String method, String url,
      {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      final msg = StringBuffer("$method $url");
      if (data != null && data.isNotEmpty) {
        // Sanitize sensitive data
        final sanitizedData = _sanitizeData(data);
        msg.write("\nData: $sanitizedData");
      }
      _log("📤 API REQUEST", _tag, msg.toString());
    }
  }

  /// Log API responses
  static void apiResponse(String method, String url, int statusCode,
      {dynamic data}) {
    if (kDebugMode) {
      final msg = StringBuffer("$method $url → $statusCode");
      if (data != null) {
        final dataStr = data.toString();
        final truncated =
            dataStr.length > 200 ? dataStr.substring(0, 200) : dataStr;
        msg.write("\nResponse: $truncated");
      }
      _log("📥 API RESPONSE", _tag, msg.toString());
    } else {
      // In production, log only status without data
      _log("📥 API RESPONSE", _tag, "$method $url → $statusCode");
    }
  }

  /// Log API errors
  static void apiError(
      String method, String url, int? statusCode, String error) {
    final msg = "$method $url → ${statusCode ?? 'N/A'}\nError: $error";
    _log("🔥 API ERROR", _tag, msg);
  }

  /// Log network errors
  static void networkError(String message, {Object? error}) {
    final msg = StringBuffer(message);
    if (error != null) {
      msg.write("\nDetails: $error");
    }
    _log("📡 NETWORK ERROR", _tag, msg.toString());
  }

  /// Log user actions
  static void userAction(String action, {Map<String, dynamic>? details}) {
    if (kDebugMode) {
      final msg = StringBuffer(action);
      if (details != null && details.isNotEmpty) {
        msg.write("\nDetails: $details");
      }
      _log("👤 USER ACTION", _tag, msg.toString());
    }
  }

  /// Internal logging method
  static void _log(String level, String tag, String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = "[$timestamp] $level [$tag] $message";

    if (kDebugMode) {
      // Use developer.log for better debugging in Flutter DevTools
      developer.log(
        message,
        time: DateTime.now(),
        name: "$level [$tag]",
      );
    }

    // Also print to console
    debugPrint(logMessage);
  }

  /// Log successful operations
  static void success(String message, {String? tag}) {
    _log("✅ SUCCESS", tag ?? _tag, message);
  }

  /// Sanitize sensitive data from logs
  static Map<String, dynamic> _sanitizeData(Map<String, dynamic> data) {
    final sanitized = Map<String, dynamic>.from(data);
    final sensitiveKeys = [
      'password',
      'token',
      'access_token',
      'refresh_token',
      'api_key',
      'secret',
      'authorization',
      'card_number',
      'cvv',
      'pin',
    ];

    for (final key in sensitiveKeys) {
      if (sanitized.containsKey(key)) {
        sanitized[key] = '[REDACTED]';
      }
    }

    return sanitized;
  }
}
