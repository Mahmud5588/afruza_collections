import "package:dio/dio.dart";

import "logger.dart";

/// Backend'da qaysi featurelar mavjudligini tekshiradi
class FeatureAvailabilityService {
  FeatureAvailabilityService(this.dio);

  final Dio dio;
  final Map<String, bool> _cache = {};

  /// Comments feature backend'da mavjudmi?
  Future<bool> isCommentsAvailable() async {
    return _checkFeature(
      "comments",
      "/health", // Yoki maxsus endpoint: /api/features
      fallback: false, // Backend tayyor bo'lmasa false qaytaradi
    );
  }

  /// Future feature: Chat notifications
  Future<bool> isChatNotificationsAvailable() async {
    return _checkFeature("chat_notifications", "/notifications",
        fallback: true);
  }

  /// Future feature: Live delivery tracking
  Future<bool> isDeliveryTrackingAvailable() async {
    return _checkFeature("delivery_tracking", "/orders/1/track",
        fallback: false);
  }

  /// Generic feature checker
  Future<bool> _checkFeature(
    String featureName,
    String testEndpoint, {
    required bool fallback,
  }) async {
    // Cache'dan o'qish
    if (_cache.containsKey(featureName)) {
      return _cache[featureName]!;
    }

    try {
      // Test endpoint'ga so'rov yuborish
      final response = await dio.get(
        testEndpoint,
        options: Options(
          validateStatus: (status) => status! < 500, // 404 ham OK
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

      // 404 = Feature yo'q, 200/201 = Feature mavjud
      final available = response.statusCode! < 400;
      _cache[featureName] = available;

      if (available) {
        AppLogger.info("✅ Feature available: $featureName");
      } else {
        AppLogger.info("⏳ Feature not yet available: $featureName");
      }

      return available;
    } catch (error) {
      // Backend xatolik bersa yoki timeout bo'lsa
      AppLogger.warning(
        "Feature check failed for $featureName, using fallback: $fallback",
      );
      _cache[featureName] = fallback;
      return fallback;
    }
  }

  /// Cache'ni tozalash (yangi check uchun)
  void clearCache() {
    _cache.clear();
  }
}
