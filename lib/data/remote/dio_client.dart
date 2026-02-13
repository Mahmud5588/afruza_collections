import "package:dio/dio.dart";

import "../../core/app_config.dart";
import "../../core/logger.dart";
import "../../core/security/ssl_pinning.dart";
import "../../core/security/token_security.dart";
import "../local/storage_service.dart";

Dio buildDioClient(StorageService storage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate",
      },
    ),
  );

  // Enable SSL Certificate Pinning for security
  SslPinning.configureSslPinning(dio);

  // Logging interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token
        final token = await storage.readToken();
        if (token != null) {
          // Validate token format before sending
          if (TokenSecurity.isValidTokenFormat(token)) {
            options.headers["Authorization"] = "Bearer $token";
          } else {
            AppLogger.warning("Invalid token format detected");
          }
        }

        // Log request (sanitized)
        AppLogger.apiRequest(
          options.method,
          options.path,
          data:
              options.data is Map ? options.data as Map<String, dynamic> : null,
        );

        handler.next(options);
      },
      onResponse: (response, handler) {
        // Log response
        AppLogger.apiResponse(
          response.requestOptions.method,
          response.requestOptions.path,
          response.statusCode ?? 0,
          data: response.data,
        );
        handler.next(response);
      },
      onError: (error, handler) {
        // Log error
        AppLogger.apiError(
          error.requestOptions.method,
          error.requestOptions.path,
          error.response?.statusCode,
          error.message ?? "Unknown error",
        );
        handler.next(error);
      },
    ),
  );

  return dio;
}
