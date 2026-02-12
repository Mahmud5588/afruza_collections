part of "order_bloc.dart";

enum OrderStatus { initial, loading, success, failure }

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {
  const LoadOrders({this.skip, this.limit});

  final int? skip;
  final int? limit;

  @override
  List<Object?> get props => [skip, limit];
}

class LoadMoreOrders extends OrderEvent {
  const LoadMoreOrders();
}
