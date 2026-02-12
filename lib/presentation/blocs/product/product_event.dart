part of "product_bloc.dart";

enum ProductStatus { initial, loading, success, empty, failure }

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts({
    this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.skip,
    this.limit,
  });

  final String? query;
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final int? skip;
  final int? limit;

  @override
  List<Object?> get props => [query, categoryId, minPrice, maxPrice, skip, limit];
}

class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}
