import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sentry_flutter/sentry_flutter.dart";

import "app.dart";
import "core/app_config.dart";
import "core/di.dart";
import "core/localization/locale_controller.dart";
import "core/logger.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info("🚀 Starting Afruza Collection App...");

  // Performance optimizations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  AppLogger.info("⚙️ Configuring dependencies...");
  await configureDependencies();
  await sl<LocaleController>().load();

  // Log configuration
  AppLogger.info("📡 API Base URL: ${AppConfig.apiBaseUrl}");
  AppLogger.info(
      "🧪 Mock Mode: ${AppConfig.useMockData ? 'ENABLED' : 'DISABLED'}");
  AppLogger.info(
      "⏱️ Timeouts - Connect: ${AppConfig.connectTimeout.inSeconds}s, Receive: ${AppConfig.receiveTimeout.inSeconds}s");

  if (AppConfig.useMockData) {
    AppLogger.warning("⚠️ MOCK MODE ACTIVE - Using test data");
    AppLogger.debug("📧 Test credentials: admin@afruza.com / admin123");
  } else {
    AppLogger.success("✅ PRODUCTION MODE - Connected to real API");
  }

  if (AppConfig.sentryDsn.isEmpty) {
    AppLogger.info("▶️ Starting app without Sentry...");
    runApp(const AfruzaApp());
    return;
  }

  AppLogger.info("🔍 Initializing Sentry monitoring...");
  await SentryFlutter.init(
    (options) {
      options.dsn = AppConfig.sentryDsn;
      options.environment = AppConfig.sentryEnvironment;
      options.tracesSampleRate = 0.05;
    },
    appRunner: () {
      AppLogger.success("✅ App started successfully!");
      runApp(const AfruzaApp());
    },
  );
}
