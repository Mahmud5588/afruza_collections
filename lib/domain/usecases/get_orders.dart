import "../entities/order.dart";
import "../entities/paged_result.dart";
import "../repositories/order_repository.dart";

class GetOrders {
  const GetOrders(this.repository);

  final OrderRepository repository;

  Future<PagedResult<Order>> call({int? skip, int? limit}) {
    return repository.fetchOrders(skip: skip, limit: limit);
  }
}
