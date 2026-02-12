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
    on<RetryLoadProducts>(_onRetryLoadProducts);
  }

  final GetProducts _getProducts;
  static const int _pageSize = 20;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

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

    await _loadProductsWithRetry(
      emit: emit,
      query: event.query,
      categoryId: event.categoryId,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      skip: event.skip ?? 0,
      limit: event.limit ?? _pageSize,
    );
  }

  Future<void> _onRetryLoadProducts(
    RetryLoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    // Show retry message
    emit(state.copyWith(message: "Retrying..."));
    await Future.delayed(_retryDelay);

    await _loadProductsWithRetry(
      emit: emit,
      query: state.query,
      categoryId: state.categoryId,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      skip: 0,
      limit: _pageSize,
    );
  }

  Future<void> _loadProductsWithRetry({
    required Emitter<ProductState> emit,
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    required int skip,
    required int limit,
  }) async {
    int retryCount = 0;
    while (retryCount < _maxRetries) {
      try {
        final result = await _getProducts(
          query: query,
          categoryId: categoryId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          skip: skip,
          limit: limit,
        );
        final products = result.items;
        final reachedMax = result.nextSkip == null;
        emit(state.copyWith(
          status:
              products.isEmpty ? ProductStatus.empty : ProductStatus.success,
          products: products,
          hasReachedMax: reachedMax,
          isLoadingMore: false,
          message: null,
        ));
        return;
      } catch (error) {
        retryCount++;
        if (retryCount < _maxRetries) {
          // Wait before retry on slow networks
          await Future.delayed(_retryDelay);
          final message = "Retrying ($retryCount/$_maxRetries)...";
          emit(state.copyWith(message: message));
        } else {
          // Final failure
          final message =
              error is ApiException ? error.message : "Failed to load products";
          emit(state.copyWith(status: ProductStatus.failure, message: message));
        }
      }
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

    int retryCount = 0;
    while (retryCount < _maxRetries) {
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
          message: null,
        ));
        return;
      } catch (error) {
        retryCount++;
        if (retryCount < _maxRetries) {
          await Future.delayed(_retryDelay);
        } else {
          final message = error is ApiException
              ? error.message
              : "Failed to load more products";
          emit(state.copyWith(isLoadingMore: false, message: message));
        }
      }
    }
  }
}
