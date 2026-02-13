import "package:flutter/material.dart";

import "core/theme.dart";
import "core/di.dart";
import "core/localization/app_localizations.dart";
import "core/localization/locale_controller.dart";
import "presentation/screens/admin/admin_panel_screen.dart";
import "presentation/screens/admin/admin_category_screen.dart";
import "presentation/screens/admin/admin_product_screen.dart";
import "presentation/screens/admin/admin_user_screen.dart";
import "presentation/screens/admin/admin_gate.dart";
import "presentation/screens/auth/login_screen.dart";
import "presentation/screens/auth/signup_screen.dart";
import "presentation/screens/chat/chat_screen.dart";
import "presentation/screens/chat/chat_list_screen.dart";
import "presentation/screens/favorites/favorites_screen.dart";
import "presentation/screens/orders/order_history_screen.dart";
import "presentation/screens/product/product_detail_screen.dart";
import "presentation/screens/profile/profile_screen.dart";
import "presentation/screens/profile/profile_settings_screen.dart";
import "presentation/screens/root/root_screen.dart";
import "presentation/screens/splash/splash_screen.dart";

class AfruzaApp extends StatelessWidget {
  const AfruzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = sl<LocaleController>();
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeController,
      builder: (context, locale, _) {
        return MaterialApp(
          title: "Afruza Collection",
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates
              .cast<LocalizationsDelegate<dynamic>>(),
          // Performance optimizations
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(),
          ),
          builder: (context, child) {
            // Prevent font scaling for consistency
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
          initialRoute: "/",
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case "/admin":
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const AdminGate(child: AdminPanelScreen()),
                );
              case "/admin/categories":
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const AdminGate(child: AdminCategoryScreen()),
                );
              case "/admin/products":
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const AdminGate(child: AdminProductScreen()),
                );
              case "/admin/users":
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => const AdminGate(child: AdminUserScreen()),
                );
            }
            return null;
          },
          routes: {
            "/": (_) => const SplashScreen(),
            "/root": (_) => const RootScreen(),
            "/login": (_) => const LoginScreen(),
            "/signup": (_) => const SignupScreen(),
            "/chat": (_) => const ChatScreen(),
            "/chat_list": (_) => const ChatListScreen(),
            "/favorites": (_) => const FavoritesScreen(),
            "/product": (_) => const ProductDetailScreen(),
            "/orders": (_) => const OrderHistoryScreen(),
            "/profile": (_) => const ProfileScreen(),
            "/profile/settings": (_) => const ProfileSettingsScreen(),
          },
        );
      },
    );
  }
}
