import "../repositories/product_repository.dart";

class UpdateProduct {
  const UpdateProduct(this.repository);

  final ProductRepository repository;

  Future<void> call({
    required int productId,
    required String name,
    required String description,
    required double price,
    required double rating,
    required int categoryId,
    required List<String> images,
    required List<Map<String, dynamic>> variants,
  }) {
    return repository.updateProduct(
      productId: productId,
      name: name,
      description: description,
      price: price,
      rating: rating,
      categoryId: categoryId,
      images: images,
      variants: variants,
    );
  }
}
