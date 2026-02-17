import "../../core/app_config.dart";
import "../../domain/entities/order.dart";
import "../../domain/entities/paged_result.dart";
import "../../domain/repositories/order_repository.dart";
import "mock_data_source.dart";

/// Mock Order Repository - Backend tayyor bo'lgunicha test qilish uchun
class OrderRepositoryMock implements OrderRepository {
  static final List<Order> _orders = List.from(MockDataSource.orders);

  @override
  Future<PagedResult<Order>> fetchOrders({int? skip, int? limit}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 400));

    final skipValue = skip ?? 0;
    final limitValue = limit ?? _orders.length;

    final items = _orders.skip(skipValue).take(limitValue).toList();
    final nextSkip =
        skipValue + limitValue < _orders.length ? skipValue + limitValue : null;

    return PagedResult<Order>(
      items: items,
      total: _orders.length,
      skip: skipValue,
      limit: limitValue,
      nextSkip: nextSkip,
    );
  }

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
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Mock mahsulotni topish
    final products = MockDataSource.products;
    final product = products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception("Mahsulot topilmadi!"),
    );

    double price = product.price;
    if (variantId != null) {
      final variant = product.variants.firstWhere(
        (v) => v.id == variantId,
        orElse: () => product.variants.first,
      );
      price = variant.price;
    }

    final newId = _orders.isEmpty
        ? 1
        : _orders.map((o) => o.id).reduce((a, b) => a > b ? a : b) + 1;

    _orders.add(Order(
      id: newId,
      status: "pending",
      createdAt: DateTime.now(),
      total: price * quantity,
      items: [
        OrderItem(
          productName: product.name,
          quantity: quantity,
          unitPrice: price,
        ),
      ],
    ));
  }

  @override
  Future<void> updateOrderStatus(
      {required int orderId, required String status}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock: statusni yangilash
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = Order(
        id: order.id,
        status: status,
        createdAt: order.createdAt,
        total: order.total,
        items: order.items,
      );
    }
  }
}
