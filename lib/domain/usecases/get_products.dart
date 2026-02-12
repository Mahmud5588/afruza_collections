import "../entities/paged_result.dart";
import "../entities/product.dart";
import "../repositories/product_repository.dart";

class GetProducts {
  final ProductRepository repository;

  const GetProducts(this.repository);

  Future<PagedResult<Product>> call({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int? skip,
    int? limit,
  }) {
    return repository.fetchProducts(
      query: query,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      skip: skip,
      limit: limit,
    );
  }
}
