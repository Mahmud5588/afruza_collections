import "dart:async";

import "package:flutter/material.dart";

import "../../../core/di.dart";
import "../../../core/ui_constants.dart";
import "../../../data/local/storage_service.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _timer = Timer(const Duration(milliseconds: 1500), _goNext);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    if (!mounted) {
      return;
    }
    final storage = sl<StorageService>();
    final isValid = await storage.isTokenValid(const Duration(days: 30));
    if (!isValid) {
      await storage.clearToken();
    }
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, "/root");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/branding/logo.png",
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                "Afruza Collection",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                "Minimal couture, curated daily",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _fade,
                child: const _LoadingDots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Dot(color: color),
        const SizedBox(width: 8),
        _Dot(color: color.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        _Dot(color: color.withValues(alpha: 0.3)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
