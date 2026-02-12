import "../entities/paged_result.dart";
import "../entities/product.dart";

abstract class ProductRepository {
  Future<PagedResult<Product>> fetchProducts({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int? skip,
    int? limit,
  });

  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required double rating,
    required int categoryId,
    required List<String> images,
    required List<Map<String, dynamic>> variants,
  });

  Future<void> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    required double rating,
    required int categoryId,
    required List<String> images,
    required List<Map<String, dynamic>> variants,
  });

  Future<void> deleteProduct({required int productId});
}
