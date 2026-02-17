import "../../domain/entities/category.dart";
import "../../core/app_config.dart";

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
  });

  final int id;
  final String name;
  final String? icon;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final iconUrl = json["icon_url"] as String?;
    String? fullIconUrl;

    if (iconUrl != null) {
      // Agar URL relative bo'lsa (/media/...), baseUrl bilan qo'shamiz
      // Emoji bo'lsa (👕) yoki to'liq URL bo'lsa (https://...) o'zgartirmaymiz
      if (iconUrl.startsWith('/')) {
        fullIconUrl = '${AppConfig.apiBaseUrl}$iconUrl';
      } else {
        fullIconUrl = iconUrl;
      }
    }

    return CategoryModel(
      id: json["id"] as int,
      name: json["name"] as String,
      icon: fullIconUrl,
    );
  }

  Category toEntity() => Category(id: id, name: name, icon: icon);
}
