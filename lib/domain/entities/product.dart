class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String categoryName;
  final int? categoryId;
  final List<String> imageUrls;
  final List<ProductVariant> variants;
  final int viewsCount;
  final int soldCount;
  final DateTime? createdAt;

  const Product({
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
}

class ProductVariant {
  final int id;
  final String name;
  final double price;

  const ProductVariant({
    required this.id,
    required this.name,
    required this.price,
  });
}
