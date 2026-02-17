import "package:dio/dio.dart";

import "../../core/logger.dart";
import "../../domain/entities/order.dart";
import "../../domain/entities/paged_result.dart";
import "../../domain/repositories/order_repository.dart";
import "../models/order_model.dart";
import "../remote/error_mapper.dart";

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<void> createOrder({
    required int productId,
    int? variantId,
    required int quantity,
    required String deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
    String? deliveryNote,
  }) async {
    try {
      AppLogger.info("Creating order for product: $productId");
      await dio.post(
        "/orders",
        data: {
          "items": [
            {
              "product_id": productId,
              if (variantId != null) "variant_id": variantId,
              "quantity": quantity
            },
          ],
          "delivery_address_text": deliveryAddress,
          if (deliveryLat != null) "delivery_lat": deliveryLat,
          if (deliveryLng != null) "delivery_lng": deliveryLng,
          if (deliveryNote != null) "delivery_note": deliveryNote,
        },
      );
      AppLogger.success("Order created successfully");
    } on DioException catch (error) {
      AppLogger.error("Order creation failed", error: error);
      throw mapDioError(error);
    }
  }

  @override
  Future<void> updateOrderStatus(
      {required int orderId, required String status}) async {
    try {
      AppLogger.info("Updating order $orderId status to: $status");
      await dio.patch("/orders/$orderId/status", data: {"status": status});
      AppLogger.success("Order status updated successfully");
    } on DioException catch (error) {
      AppLogger.error("Order status update failed", error: error);
      throw mapDioError(error);
    }
  }

  @override
  Future<PagedResult<Order>> fetchOrders({int? skip, int? limit}) async {
    try {
      final response = await dio.get(
        "/orders/me/paged",
        queryParameters: {
          if (skip != null) "skip": skip,
          if (limit != null) "limit": limit,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final data = payload["items"] as List<dynamic>? ?? [];
      final items = data
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
      return PagedResult<Order>(
        items: items,
        total: payload["total"] as int? ?? items.length,
        skip: payload["skip"] as int? ?? (skip ?? 0),
        limit: payload["limit"] as int? ?? (limit ?? items.length),
        nextSkip: payload["next_skip"] as int?,
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
