import "package:flutter/material.dart";

import "../../../core/di.dart";
import "../../../core/logger.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/ui_constants.dart";
import "../../../data/local/storage_service.dart";

class AdminGate extends StatelessWidget {
  const AdminGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _checkAdminAccess(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data ?? {};
        final isAdmin = data['isAdmin'] as bool? ?? false;
        final hasToken = data['hasToken'] as bool? ?? false;

        if (!isAdmin || !hasToken) {
          final t = AppLocalizations.of(context).t;
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(gradient: AppGradients.hero),
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline,
                            size: 48,
                            color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(height: 16),
                        Text(
                          hasToken ? t("access_denied") : t("login_required"),
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hasToken
                              ? t("admin_only")
                              : "Iltimos, admin sifatida login qiling",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () {
                            if (!hasToken) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                "/login",
                                (route) => route.settings.name == "/root",
                              );
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text(hasToken ? t("go_back") : "Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return child;
      },
    );
  }

  Future<Map<String, dynamic>> _checkAdminAccess() async {
    final storage = sl<StorageService>();

    // First check if token exists
    final token = await storage.readToken();
    final hasToken = token != null && token.isNotEmpty;

    AppLogger.debug(
        "Admin Gate Check - Has token: $hasToken (length: ${token?.length ?? 0})");

    if (!hasToken) {
      AppLogger.warning("No token found, clearing admin flag");
      await storage.clearToken();
      return {
        'isAdmin': false,
        'hasToken': false,
      };
    }

    // Check admin flag
    final isAdmin = await storage.readIsAdmin();
    AppLogger.debug("Admin Gate Check - isAdmin: $isAdmin");

    return {
      'isAdmin': isAdmin,
      'hasToken': hasToken,
    };
  }
}
