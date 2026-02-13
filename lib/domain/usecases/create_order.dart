import "../repositories/order_repository.dart";

class CreateOrder {
  const CreateOrder(this.repository);

  final OrderRepository repository;

  Future<void> call({
    required int productId,
    int? variantId,
    required int quantity,
    String? deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    String? deliveryNote,
  }) {
    return repository.createOrder(
      productId: productId,
      variantId: variantId,
      quantity: quantity,
      deliveryAddress: deliveryAddress ?? "Delivery address not specified",
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
      deliveryNote: deliveryNote,
    );
  }
}
