import "../../domain/entities/order.dart";

class OrderModel {
  OrderModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  final int id;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json["items"] as List<dynamic>? ?? [];
    final items = itemsJson
        .whereType<Map<String, dynamic>>()
        .map(OrderItemModel.fromJson)
        .toList();

    return OrderModel(
      id: json["id"] as int,
      status: json["status"] as String? ?? "Pending",
      createdAt: DateTime.parse(json["created_at"] as String),
      items: items,
    );
  }

  Order toEntity() {
    final total = items.fold<double>(0, (sum, item) {
      return sum + (item.unitPrice * item.quantity);
    });

    return Order(
      id: id,
      status: status,
      createdAt: createdAt,
      total: total,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }
}

class OrderItemModel {
  OrderItemModel({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productName;
  final int quantity;
  final double unitPrice;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json["product"] as Map<String, dynamic>? ?? {};
    return OrderItemModel(
      productName: product["name"] as String? ?? "Item",
      quantity: json["quantity"] as int? ?? 0,
      unitPrice: (json["unit_price"] as num?)?.toDouble() ?? 0,
    );
  }

  OrderItem toEntity() {
    return OrderItem(
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }
}
