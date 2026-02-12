import "package:flutter/material.dart";

/// Category icon mapper - backend icon codeni IconData ga mapping qiladi
class CategoryIcons {
  static IconData getIcon(String? iconCode) {
    if (iconCode == null || iconCode.isEmpty) {
      return Icons.category_outlined;
    }

    // Backend icon code mapping
    switch (iconCode.toLowerCase()) {
      case "dress":
      case "ko'ylak":
        return Icons.checkroom_outlined;
      case "suit":
      case "kostyum":
        return Icons.business_center_outlined;
      case "shoes":
      case "oyoq_kiyim":
      case "poyabzal":
        return Icons.local_mall_outlined;
      case "bag":
      case "sumka":
        return Icons.shopping_bag_outlined;
      case "accessories":
      case "aksessuarlar":
        return Icons.watch_outlined;
      case "jewelry":
      case "zargarlik":
        return Icons.diamond_outlined;
      case "hat":
      case "shapka":
        return Icons.headset_outlined;
      case "sport":
        return Icons.sports_outlined;
      case "casual":
        return Icons.weekend_outlined;
      case "formal":
        return Icons.nightlife_outlined;
      case "kids":
      case "bolalar":
        return Icons.child_care_outlined;
      case "women":
      case "ayollar":
        return Icons.woman_outlined;
      case "men":
      case "erkaklar":
        return Icons.man_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  /// Default categoriyalar uchun fallback icons
  static IconData getDefaultIcon(String categoryName) {
    final lowerName = categoryName.toLowerCase();

    if (lowerName.contains("ko'ylak") || lowerName.contains("dress")) {
      return Icons.checkroom_outlined;
    }
    if (lowerName.contains("kostyum") || lowerName.contains("suit")) {
      return Icons.business_center_outlined;
    }
    if (lowerName.contains("oyoq") ||
        lowerName.contains("shoe") ||
        lowerName.contains("poyabzal")) {
      return Icons.local_mall_outlined;
    }
    if (lowerName.contains("sumka") || lowerName.contains("bag")) {
      return Icons.shopping_bag_outlined;
    }
    if (lowerName.contains("aksessuar") || lowerName.contains("accessor")) {
      return Icons.watch_outlined;
    }
    if (lowerName.contains("zargar") || lowerName.contains("jewelry")) {
      return Icons.diamond_outlined;
    }
    if (lowerName.contains("sport")) {
      return Icons.sports_outlined;
    }
    if (lowerName.contains("bola") ||
        lowerName.contains("kid") ||
        lowerName.contains("child")) {
      return Icons.child_care_outlined;
    }
    if (lowerName.contains("ayol") || lowerName.contains("women")) {
      return Icons.woman_outlined;
    }
    if (lowerName.contains("erkak") || lowerName.contains("men")) {
      return Icons.man_outlined;
    }

    return Icons.category_outlined;
  }
}
