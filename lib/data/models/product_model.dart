import "../../domain/entities/product.dart";

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryName,
    required this.imageUrls,
    required this.variants,
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String categoryName;
  final List<String> imageUrls;
  final List<ProductVariantModel> variants;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json["category"] as Map<String, dynamic>? ?? {};
    final images = (json["images"] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((item) => item["url"] as String)
        .toList();
    final variantsJson = (json["variants"] as List<dynamic>? ?? [])
      .whereType<Map<String, dynamic>>()
      .map(ProductVariantModel.fromJson)
      .toList();

    return ProductModel(
      id: json["id"] as int,
      name: json["name"] as String,
      description: json["description"] as String,
      price: (json["price"] as num).toDouble(),
      rating: (json["rating"] as num?)?.toDouble() ?? 0,
      categoryName: category["name"] as String? ?? "Uncategorized",
      imageUrls: images,
      variants: variantsJson,
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
      imageUrls: imageUrls,
      variants: variants.map((variant) => variant.toEntity()).toList(),
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
