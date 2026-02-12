class Order {
  final int id;
  final String status;
  final DateTime createdAt;
  final double total;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.total,
    required this.items,
  });
}

class OrderItem {
  final String productName;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });
}
