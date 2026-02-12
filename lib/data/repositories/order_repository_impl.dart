import "package:dio/dio.dart";

import "../../domain/entities/order.dart";
import "../../domain/entities/paged_result.dart";
import "../../domain/repositories/order_repository.dart";
import "../models/order_model.dart";
import "../remote/error_mapper.dart";

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<void> createOrder(
      {required int productId, int? variantId, required int quantity}) async {
    try {
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
        },
      );
    } on DioException catch (error) {
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
