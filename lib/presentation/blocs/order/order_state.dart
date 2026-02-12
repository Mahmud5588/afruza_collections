part of "order_bloc.dart";

class OrderState extends Equatable {
  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.message,
  });

  final OrderStatus status;
  final List<Order> orders;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? message;

  OrderState copyWith({
    OrderStatus? status,
    List<Order>? orders,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? message,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, orders, isLoadingMore, hasReachedMax, message];
}
