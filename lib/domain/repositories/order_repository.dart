import "../entities/order.dart";
import "../entities/paged_result.dart";

abstract class OrderRepository {
  Future<PagedResult<Order>> fetchOrders({int? skip, int? limit});
  Future<void> createOrder({
    required int productId,
    int? variantId,
    required int quantity,
    required String deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    String? deliveryNote,
  });
}
