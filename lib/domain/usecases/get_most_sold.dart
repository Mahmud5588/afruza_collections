import "../entities/product.dart";
import "../repositories/recommendation_repository.dart";

class GetMostSold {
  const GetMostSold(this.repository);

  final RecommendationRepository repository;

  Future<List<Product>> call({int limit = 10}) {
    return repository.fetchMostSold(limit: limit);
  }
}
