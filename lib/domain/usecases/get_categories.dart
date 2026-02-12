import "../entities/category.dart";
import "../entities/paged_result.dart";
import "../repositories/category_repository.dart";

class GetCategories {
  const GetCategories(this.repository);

  final CategoryRepository repository;

  Future<PagedResult<Category>> call({int? skip, int? limit}) {
    return repository.fetchCategories(skip: skip, limit: limit);
  }
}
