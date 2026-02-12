import "../../core/app_config.dart";
import "../../domain/entities/product.dart";
import "../../domain/repositories/recommendation_repository.dart";
import "mock_data_source.dart";

/// Mock Recommendation Repository - Backend tayyor bo'lgunicha test qilish uchun
class RecommendationRepositoryMock implements RecommendationRepository {
  @override
  Future<List<Product>> fetchMostViewed({int limit = 10}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    // En yuqori reyting bo'lgan mahsulotlar
    final products = List<Product>.from(MockDataSource.products);
    products.sort((a, b) => b.rating.compareTo(a.rating));

    return products.take(limit).toList();
  }

  @override
  Future<List<Product>> fetchMostSold({int limit = 10}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Eng qimmat mahsulotlar (mock uchun sotilgan deb hisoblaymiz)
    final products = List<Product>.from(MockDataSource.products);
    products.sort((a, b) => b.price.compareTo(a.price));

    return products.take(limit).toList();
  }
}
