import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../../../domain/entities/order.dart";
import "../../../domain/usecases/get_orders.dart";
import "../../../data/remote/api_exception.dart";

part "order_event.dart";
part "order_state.dart";

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(this._getOrders) : super(const OrderState()) {
    on<LoadOrders>(_onLoadOrders);
    on<LoadMoreOrders>(_onLoadMoreOrders);
  }

  final GetOrders _getOrders;
  static const int _pageSize = 20;

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(
      status: OrderStatus.loading,
      orders: const [],
      isLoadingMore: false,
      hasReachedMax: false,
      message: null,
    ));
    try {
      final result = await _getOrders(
        skip: event.skip ?? 0,
        limit: event.limit ?? _pageSize,
      );
      final orders = result.items;
      final reachedMax = result.nextSkip == null;
      emit(state.copyWith(
        status: OrderStatus.success,
        orders: orders,
        hasReachedMax: reachedMax,
      ));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load orders";
      emit(state.copyWith(status: OrderStatus.failure, message: message));
    }
  }

  Future<void> _onLoadMoreOrders(
    LoadMoreOrders event,
    Emitter<OrderState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) {
      return;
    }
    if (state.status != OrderStatus.success) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    try {
      final result = await _getOrders(
        skip: state.orders.length,
        limit: _pageSize,
      );
      final orders = result.items;
      if (orders.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasReachedMax: true));
        return;
      }
      emit(state.copyWith(
        orders: [...state.orders, ...orders],
        isLoadingMore: false,
        hasReachedMax: result.nextSkip == null,
      ));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load orders";
      emit(state.copyWith(isLoadingMore: false, message: message));
    }
  }
}
