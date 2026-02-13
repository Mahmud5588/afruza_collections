class AppConfig {
  /// Production API base URL
  static const String apiBaseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "https://bek85.me",
  );

  static const String sentryDsn = String.fromEnvironment(
    "SENTRY_DSN",
    defaultValue: "",
  );

  static const String sentryEnvironment = String.fromEnvironment(
    "SENTRY_ENVIRONMENT",
    defaultValue: "production",
  );

  /// Mock mode - faqat testing uchun
  static const bool useMockData = bool.fromEnvironment(
    "USE_MOCK_DATA",
    defaultValue: false, // Real API ishlatish
  );

  /// API timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
