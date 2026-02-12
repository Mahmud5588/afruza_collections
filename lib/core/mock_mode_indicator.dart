import "package:flutter/material.dart";
import "app_config.dart";

/// Mock mode status widget - Debug rejimi uchun
class MockModeIndicator extends StatelessWidget {
  const MockModeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Release mode'da ko'rsatmaymiz
    if (const bool.fromEnvironment("dart.vm.product")) {
      return const SizedBox.shrink();
    }

    // Mock mode yoqilgan bo'lsa ko'rsatamiz
    if (!AppConfig.useMockData) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.science,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            "MOCK MODE",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
