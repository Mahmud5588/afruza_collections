import "package:dio/dio.dart";

import "../../core/app_config.dart";
import "../local/storage_service.dart";

Dio buildDioClient(StorageService storage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      // Slow internet optimization: longer timeouts
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      // Compression support for smaller payloads
      headers: {
        "Accept-Encoding": "gzip, deflate",
        "Content-Type": "application/json",
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.readToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle timeout and retry for slow networks
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          print("Network timeout - retry available");
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}
