import "../entities/product.dart";

abstract class RecommendationRepository {
  Future<List<Product>> fetchMostViewed({int limit = 10});
  Future<List<Product>> fetchMostSold({int limit = 10});
}
