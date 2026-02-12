import "../repositories/product_repository.dart";

class CreateProduct {
  const CreateProduct(this.repository);

  final ProductRepository repository;

  Future<void> call({
    required String name,
    required String description,
    required double price,
    required double rating,
    required int categoryId,
    required List<String> images,
    required List<Map<String, dynamic>> variants,
  }) {
    return repository.createProduct(
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
