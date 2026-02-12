import "../repositories/category_repository.dart";

class UpdateCategory {
  const UpdateCategory(this.repository);

  final CategoryRepository repository;

  Future<void> call({required int categoryId, required String name}) {
    return repository.updateCategory(categoryId: categoryId, name: name);
  }
}
