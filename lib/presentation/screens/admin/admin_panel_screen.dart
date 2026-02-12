import "package:flutter/material.dart";

import "../../../core/di.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../core/ui_constants.dart";
import "../../../domain/usecases/get_categories.dart";
import "../../../domain/usecases/get_products.dart";
import "../../../domain/usecases/get_users.dart";

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

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
                  Text(t("admin_panel_title"),
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _AdminStatsSection(),
              const SizedBox(height: AppSpacing.lg),
              Text(t("quick_actions"),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _AdminQuickActions(
                onProducts: () =>
                    Navigator.pushNamed(context, "/admin/products"),
                onCategories: () =>
                    Navigator.pushNamed(context, "/admin/categories"),
                onUsers: () => Navigator.pushNamed(context, "/admin/users"),
                onChat: () => Navigator.pushNamed(context, "/chat_list"),
              ),
              const SizedBox(height: 20),
              Text(t("management"),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _AdminTile(
                title: t("add_product"),
                subtitle: t("publish_drop"),
                icon: Icons.add_box_outlined,
                onTap: () => Navigator.pushNamed(context, "/admin/products"),
              ),
              const SizedBox(height: 16),
              _AdminTile(
                title: t("manage_categories"),
                subtitle: t("organize_collection"),
                icon: Icons.category_outlined,
                onTap: () => Navigator.pushNamed(context, "/admin/categories"),
              ),
              const SizedBox(height: 16),
              _AdminTile(
                title: t("user_management"),
                subtitle: t("roles_access"),
                icon: Icons.people_outline,
                onTap: () => Navigator.pushNamed(context, "/admin/users"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return FutureBuilder<_AdminStats>(
      future: _loadStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final stats = snapshot.data;
        if (stats == null) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t("overview"), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(label: t("products"), value: stats.products),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                      label: t("categories_count"), value: stats.categories),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StatCard(label: t("users"), value: stats.users),
          ],
        );
      },
    );
  }

  Future<_AdminStats> _loadStats() async {
    final products = await sl<GetProducts>()(limit: 200);
    final categories = await sl<GetCategories>()();
    final users = await sl<GetUsers>()(limit: 200);
    return _AdminStats(
      products: products.items.length,
      categories: categories.items.length,
      users: users.length,
    );
  }
}

class _AdminStats {
  _AdminStats({
    required this.products,
    required this.categories,
    required this.users,
  });

  final int products;
  final int categories;
  final int users;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _AdminQuickActions extends StatelessWidget {
  const _AdminQuickActions({
    required this.onProducts,
    required this.onCategories,
    required this.onUsers,
    required this.onChat,
  });

  final VoidCallback onProducts;
  final VoidCallback onCategories;
  final VoidCallback onUsers;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Column(
      children: [
        Row(
          children: [
            _QuickActionCard(
              label: t("manage_products"),
              icon: Icons.inventory_2_outlined,
              onTap: onProducts,
            ),
            const SizedBox(width: 12),
            _QuickActionCard(
              label: t("manage_categories"),
              icon: Icons.category_outlined,
              onTap: onCategories,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _QuickActionCard(
              label: t("manage_users"),
              icon: Icons.people_outline,
              onTap: onUsers,
            ),
            const SizedBox(width: 12),
            _QuickActionCard(
              label: t("chat"),
              icon: Icons.chat_bubble_outline,
              onTap: onChat,
              badge: 3, // Mock unread count
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.secondary),
                  if (badge != null && badge! > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            badge! > 9 ? "9+" : badge.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  const _AdminTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

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
