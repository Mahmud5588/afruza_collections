import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../../../domain/entities/product.dart";
import "../../../domain/usecases/get_products.dart";
import "../../../data/remote/api_exception.dart";

part "product_event.dart";
part "product_state.dart";

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(GetProducts getProducts)
      : _getProducts = getProducts,
        super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }

  final GetProducts _getProducts;
  static const int _pageSize = 20;

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(
      status: ProductStatus.loading,
      products: const [],
      hasReachedMax: false,
      query: event.query,
      categoryId: event.categoryId,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      message: null,
    ));
    try {
      final result = await _getProducts(
        query: event.query,
        categoryId: event.categoryId,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        skip: event.skip ?? 0,
        limit: event.limit ?? _pageSize,
      );
      final products = result.items;
      final reachedMax = result.nextSkip == null;
      emit(state.copyWith(
        status: products.isEmpty ? ProductStatus.empty : ProductStatus.success,
        products: products,
        hasReachedMax: reachedMax,
        isLoadingMore: false,
      ));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load products";
      emit(state.copyWith(status: ProductStatus.failure, message: message));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) {
      return;
    }
    if (state.status != ProductStatus.success) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    try {
      final result = await _getProducts(
        query: state.query,
        categoryId: state.categoryId,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        skip: state.products.length,
        limit: _pageSize,
      );
      final products = result.items;
      if (products.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasReachedMax: true));
        return;
      }
      emit(state.copyWith(
        products: [...state.products, ...products],
        isLoadingMore: false,
        hasReachedMax: result.nextSkip == null,
      ));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load products";
      emit(state.copyWith(isLoadingMore: false, message: message));
    }
  }
}
