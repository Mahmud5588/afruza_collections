part of "product_bloc.dart";

class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.message,
  });

  final ProductStatus status;
  final List<Product> products;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? query;
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? message;

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    bool? isLoadingMore,
    bool? hasReachedMax,
    Object? query = _undefined,
    Object? categoryId = _undefined,
    Object? minPrice = _undefined,
    Object? maxPrice = _undefined,
    Object? message = _undefined,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query == _undefined ? this.query : query as String?,
      categoryId:
          categoryId == _undefined ? this.categoryId : categoryId as int?,
      minPrice: minPrice == _undefined ? this.minPrice : minPrice as double?,
      maxPrice: maxPrice == _undefined ? this.maxPrice : maxPrice as double?,
      message: message == _undefined ? this.message : message as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        isLoadingMore,
        hasReachedMax,
        query,
        categoryId,
        minPrice,
        maxPrice,
        message,
      ];
}

const _undefined = Object();
