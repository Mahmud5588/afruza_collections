import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

import "../../domain/entities/product.dart";

class FavoritesService {
  FavoritesService(this.prefs);

  final SharedPreferences prefs;

  static const _favoritesKey = "favorite_products";

  Future<List<Product>> readFavorites() async {
    final raw = prefs.getStringList(_favoritesKey) ?? [];
    return raw
        .map((item) =>
            _productFromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isFavorite(int productId) async {
    final raw = prefs.getStringList(_favoritesKey) ?? [];
    return raw.any((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map["id"] == productId;
    });
  }

  Future<void> toggleFavorite(Product product) async {
    final raw = prefs.getStringList(_favoritesKey) ?? [];
    final existingIndex = raw.indexWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map["id"] == product.id;
    });

    if (existingIndex >= 0) {
      raw.removeAt(existingIndex);
    } else {
      raw.add(jsonEncode(_productToJson(product)));
    }

    await prefs.setStringList(_favoritesKey, raw);
  }

  Future<void> removeFavorite(int productId) async {
    final raw = prefs.getStringList(_favoritesKey) ?? [];
    raw.removeWhere((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return map["id"] == productId;
    });
    await prefs.setStringList(_favoritesKey, raw);
  }

  Map<String, dynamic> _productToJson(Product product) {
    return {
      "id": product.id,
      "name": product.name,
      "description": product.description,
      "price": product.price,
      "rating": product.rating,
      "category_name": product.categoryName,
      "category_id": product.categoryId,
      "image_urls": product.imageUrls,
      "variants": product.variants
          .map((variant) =>
              {"id": variant.id, "name": variant.name, "price": variant.price})
          .toList(),
      "views_count": product.viewsCount,
      "sold_count": product.soldCount,
      "created_at": product.createdAt?.toIso8601String(),
    };
  }

  Product _productFromJson(Map<String, dynamic> json) {
    final variants = (json["variants"] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => ProductVariant(
            id: item["id"] as int,
            name: item["name"] as String,
            price: (item["price"] as num).toDouble(),
          ),
        )
        .toList();

    DateTime? createdAt;
    try {
      final createdAtStr = json["created_at"] as String?;
      if (createdAtStr != null) {
        createdAt = DateTime.parse(createdAtStr);
      }
    } catch (e) {
      // Ignore parse errors
    }

    return Product(
      id: json["id"] as int,
      name: json["name"] as String,
      description: json["description"] as String,
      price: (json["price"] as num).toDouble(),
      rating: (json["rating"] as num).toDouble(),
      categoryName: json["category_name"] as String,
      categoryId: json["category_id"] as int?,
      imageUrls: (json["image_urls"] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      variants: variants,
      viewsCount: json["views_count"] as int? ?? 0,
      soldCount: json["sold_count"] as int? ?? 0,
      createdAt: createdAt,
    );
  }
}
