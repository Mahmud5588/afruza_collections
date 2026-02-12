import "../repositories/category_repository.dart";

class DeleteCategory {
  const DeleteCategory(this.repository);

  final CategoryRepository repository;

  Future<void> call({required int categoryId}) {
    return repository.deleteCategory(categoryId: categoryId);
  }
}
