import "../repositories/order_repository.dart";

class CreateOrder {
  const CreateOrder(this.repository);

  final OrderRepository repository;

  Future<void> call(
      {required int productId, int? variantId, required int quantity}) {
    return repository.createOrder(
      productId: productId,
      variantId: variantId,
      quantity: quantity,
    );
  }
}
