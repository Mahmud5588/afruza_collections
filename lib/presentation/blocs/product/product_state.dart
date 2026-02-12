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
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? message,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      message: message ?? this.message,
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
