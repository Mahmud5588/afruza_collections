class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String categoryName;
  final List<String> imageUrls;
  final List<ProductVariant> variants;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryName,
    required this.imageUrls,
    required this.variants,
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
