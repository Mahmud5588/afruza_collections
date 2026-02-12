import "../entities/product.dart";
import "../repositories/recommendation_repository.dart";

class GetMostViewed {
  const GetMostViewed(this.repository);

  final RecommendationRepository repository;

  Future<List<Product>> call({int limit = 10}) {
    return repository.fetchMostViewed(limit: limit);
  }
}
