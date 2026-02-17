import "../../domain/entities/product.dart";
import "../../core/app_config.dart";

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryName,
    this.categoryId,
    required this.imageUrls,
    required this.variants,
    this.viewsCount = 0,
    this.soldCount = 0,
    this.createdAt,
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String categoryName;
  final int? categoryId;
  final List<String> imageUrls;
  final List<ProductVariantModel> variants;
  final int viewsCount;
  final int soldCount;
  final DateTime? createdAt;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json["category"] as Map<String, dynamic>? ?? {};
    final images = (json["images"] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) {
      final url = item["url"] as String;
      // Agar URL relative bo'lsa (/media/...), baseUrl bilan qo'shamiz
      if (url.startsWith('/')) {
        return '${AppConfig.apiBaseUrl}$url';
      }
      return url;
    }).toList();
    final variantsJson = (json["variants"] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProductVariantModel.fromJson)
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

    return ProductModel(
      id: json["id"] as int,
      name: json["name"] as String,
      description: json["description"] as String,
      price: (json["price"] as num).toDouble(),
      rating: (json["rating"] as num?)?.toDouble() ?? 0,
      categoryName: category["name"] as String? ?? "Uncategorized",
      categoryId: category["id"] as int?,
      imageUrls: images,
      variants: variantsJson,
      viewsCount: json["views_count"] as int? ?? 0,
      soldCount: json["sold_count"] as int? ?? 0,
      createdAt: createdAt,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      rating: rating,
      categoryName: categoryName,
      categoryId: categoryId,
      imageUrls: imageUrls,
      variants: variants.map((variant) => variant.toEntity()).toList(),
      viewsCount: viewsCount,
      soldCount: soldCount,
      createdAt: createdAt,
    );
  }
}

class ProductVariantModel {
  ProductVariantModel({
    required this.id,
    required this.name,
    required this.price,
  });

  final int id;
  final String name;
  final double price;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json["id"] as int,
      name: json["name"] as String,
      price: (json["price"] as num).toDouble(),
    );
  }

  ProductVariant toEntity() {
    return ProductVariant(id: id, name: name, price: price);
  }
}
