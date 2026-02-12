import "package:flutter/material.dart";

import "../../../core/di.dart";
import "../../../core/localization/app_localizations.dart";
import "../../../data/local/storage_service.dart";
import "../home/home_screen.dart";
import "../orders/order_history_screen.dart";
import "../profile/profile_screen.dart";
import "../search/search_screen.dart";

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _handleTap(context, index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: t("home"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_outlined),
            activeIcon: const Icon(Icons.search),
            label: t("search"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long),
            label: t("orders"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: t("profile"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTap(BuildContext context, int index) async {
    if (index == 2) {
      final storage = sl<StorageService>();
      final isLoggedIn = await storage.isTokenValid(const Duration(days: 30));
      if (!isLoggedIn) {
        if (!context.mounted) return;
        Navigator.pushNamed(context, "/login");
        return;
      }
    }
    setState(() => _currentIndex = index);
  }
}
