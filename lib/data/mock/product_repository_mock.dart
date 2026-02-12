import "../../core/app_config.dart";
import "../../domain/entities/paged_result.dart";
import "../../domain/entities/product.dart";
import "../../domain/repositories/product_repository.dart";
import "mock_data_source.dart";

/// Mock Product Repository - Backend tayyor bo'lgunicha test qilish uchun
class ProductRepositoryMock implements ProductRepository {
  static final List<Product> _products = List.from(MockDataSource.products);

  @override
  Future<PagedResult<Product>> fetchProducts({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int? skip,
    int? limit,
  }) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 400));

    var filtered = List<Product>.from(_products);

    // Query bo'yicha filter
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(lowerQuery) ||
            p.description.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    // Kategoriya bo'yicha filter (categoryId mavjud bo'lsa)
    // Mock data'da categoryName bor, lekin categoryId yo'q
    // Shuning uchun categoryId'ni ignore qilamiz yoki categoryName bilan match qilamiz

    // Narx bo'yicha filter
    if (minPrice != null) {
      filtered = filtered.where((p) => p.price >= minPrice).toList();
    }
    if (maxPrice != null) {
      filtered = filtered.where((p) => p.price <= maxPrice).toList();
    }

    final skipValue = skip ?? 0;
    final limitValue = limit ?? filtered.length;

    final items = filtered.skip(skipValue).take(limitValue).toList();
    final nextSkip = skipValue + limitValue < filtered.length
        ? skipValue + limitValue
        : null;

    return PagedResult<Product>(
      items: items,
      total: filtered.length,
      skip: skipValue,
      limit: limitValue,
      nextSkip: nextSkip,
    );
  }

  @override
  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required double rating,
    required int categoryId,
    required List<String> images,
    required List<Map<String, dynamic>> variants,
  }) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 400));

    final newId = _products.isEmpty
        ? 1
        : _products.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;

    final variantList = variants.map((v) {
      return ProductVariant(
        id: v["id"] as int? ?? 0,
        name: v["name"] as String? ?? "",
        price: (v["price"] as num?)?.toDouble() ?? price,
      );
    }).toList();

    _products.add(Product(
      id: newId,
      name: name,
      description: description,
      price: price,
      rating: rating,
      categoryName: "Test Category", // Mock uchun
      imageUrls: images,
      variants: variantList,
    ));
  }

  @override
  Future<void> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    required double rating,
    required int categoryId,
    required List<String> images,
    required List<Map<String, dynamic>> variants,
  }) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) {
      throw Exception("Mahsulot topilmadi!");
    }

    final variantList = variants.map((v) {
      return ProductVariant(
        id: v["id"] as int? ?? 0,
        name: v["name"] as String? ?? "",
        price: (v["price"] as num?)?.toDouble() ?? price,
      );
    }).toList();

    _products[index] = Product(
      id: productId,
      name: name,
      description: description,
      price: price,
      rating: rating,
      categoryName:
          _products[index].categoryName, // Eski categoriyani saqlaymiz
      imageUrls: images,
      variants: variantList,
    );
  }

  @override
  Future<void> deleteProduct({required int productId}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    _products.removeWhere((p) => p.id == productId);
  }
}
