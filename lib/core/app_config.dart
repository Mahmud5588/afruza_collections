class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://10.0.2.2:8000",
  );

  static const String sentryDsn = String.fromEnvironment(
    "SENTRY_DSN",
    defaultValue: "",
  );

  static const String sentryEnvironment = String.fromEnvironment(
    "SENTRY_ENVIRONMENT",
    defaultValue: "development",
  );

  /// Mock mode - backend tayyor bo'lgunicha mock datalardan foydalanish
  static const bool useMockData = bool.fromEnvironment(
    "USE_MOCK_DATA",
    defaultValue: true, // Default mock mode yoqilgan
  );
}
