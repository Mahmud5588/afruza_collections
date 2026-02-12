import "../repositories/product_repository.dart";

class DeleteProduct {
  const DeleteProduct(this.repository);

  final ProductRepository repository;

  Future<void> call({required int productId}) {
    return repository.deleteProduct(productId: productId);
  }
}
