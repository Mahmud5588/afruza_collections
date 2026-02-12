import "package:flutter/material.dart";
import "package:sentry_flutter/sentry_flutter.dart";

import "app.dart";
import "core/app_config.dart";
import "core/di.dart";
import "core/localization/locale_controller.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await sl<LocaleController>().load();

  // Mock mode haqida debug ma'lumot
  if (AppConfig.useMockData) {
    debugPrint(
        "🧪 MOCK MODE YOQILGAN - Backend tayyor bo'lgunicha mock datalardan foydalaniladi");
    debugPrint("📧 Test login: admin@afruza.com / admin123");
  } else {
    debugPrint("🌐 REAL API MODE - ${AppConfig.apiBaseUrl}");
  }

  if (AppConfig.sentryDsn.isEmpty) {
    runApp(const AfruzaApp());
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = AppConfig.sentryDsn;
      options.environment = AppConfig.sentryEnvironment;
      options.tracesSampleRate = 0.05;
    },
    appRunner: () => runApp(const AfruzaApp()),
  );
}
