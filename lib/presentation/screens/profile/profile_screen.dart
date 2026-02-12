import "package:flutter/material.dart";

import "../../../core/di.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/localization/locale_controller.dart";
import "../../../core/ui_constants.dart";
import "../../../data/local/storage_service.dart";
import "../../../domain/usecases/logout_user.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  Text(t("profile"),
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _ProfileCard(
                title: t("account"),
                subtitle: t("account_subtitle"),
                icon: Icons.person_outline,
                onTap: () => Navigator.pushNamed(context, "/profile/settings"),
              ),
              const SizedBox(height: 16),
              _ProfileCard(
                title: t("orders"),
                subtitle: t("orders_subtitle"),
                icon: Icons.receipt_long,
                onTap: () => _openIfLoggedIn(context, "/orders"),
              ),
              const SizedBox(height: 16),
              _ProfileCard(
                title: t("chat"),
                subtitle: t("chat_subtitle"),
                icon: Icons.chat_bubble_outline,
                onTap: () => _openIfLoggedIn(context, "/chat"),
              ),
              const SizedBox(height: 16),
              _ProfileCard(
                title: t("favorites"),
                subtitle: t("favorites_subtitle"),
                icon: Icons.favorite_border,
                onTap: () => Navigator.pushNamed(context, "/favorites"),
              ),
              const SizedBox(height: 16),
              _ProfileCard(
                title: t("language"),
                subtitle: t("language_subtitle"),
                icon: Icons.language,
                onTap: () => _showLanguagePicker(context),
              ),
              const SizedBox(height: 16),
              FutureBuilder<bool>(
                future: sl<StorageService>().readIsAdmin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  final isAdmin = snapshot.data ?? false;
                  if (!isAdmin) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      _ProfileCard(
                        title: t("admin_panel"),
                        subtitle: t("admin_panel_subtitle"),
                        icon: Icons.admin_panel_settings_outlined,
                        onTap: () => Navigator.pushNamed(context, "/admin"),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
              _ProfileCard(
                title: t("logout"),
                subtitle: t("logout_subtitle"),
                icon: Icons.logout,
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final t = AppLocalizations.of(context).t;

    // Logout tasdiqlovchi dialog chiqarish
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(t("confirm_logout")),
            content: Text(t("logout_message")),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(t("cancel")),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(t("logout")),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    if (!context.mounted) return;
    await sl<LogoutUser>()();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  Future<void> _openIfLoggedIn(BuildContext context, String route) async {
    final t = AppLocalizations.of(context).t;
    final storage = sl<StorageService>();
    final isLoggedIn = await storage.isTokenValid(const Duration(days: 30));
    if (!context.mounted) return;

    if (!isLoggedIn) {
      // Login talab qiluvchi dialog chiqarish
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(t("login_required")),
          content: Text(t("login_required_message")),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t("cancel")),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/login");
              },
              child: Text(t("login")),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.pushNamed(context, route);
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final controller = sl<LocaleController>();
    final current = controller.value ?? const Locale("en");
    final selection = await showModalBottomSheet<Locale>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              label: "O'zbek",
              locale: const Locale("uz"),
              selected: current.languageCode == "uz",
            ),
            _LanguageOption(
              label: "Русский",
              locale: const Locale("ru"),
              selected: current.languageCode == "ru",
            ),
            _LanguageOption(
              label: "English",
              locale: const Locale("en"),
              selected: current.languageCode == "en",
            ),
          ],
        ),
      ),
    );
    if (selection != null) {
      await controller.setLocale(selection);
    }
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.locale,
    required this.selected,
  });

  final String label;
  final Locale locale;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected ? const Icon(Icons.check) : null,
      onTap: () => Navigator.pop(context, locale),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child:
                  Icon(icon, color: Theme.of(context).colorScheme.onSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
