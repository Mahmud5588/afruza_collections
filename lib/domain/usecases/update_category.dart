import "../repositories/category_repository.dart";

class UpdateCategory {
  const UpdateCategory(this.repository);

  final CategoryRepository repository;

  Future<void> call(
      {required int categoryId, required String name, String? iconUrl}) {
    return repository.updateCategory(
        categoryId: categoryId, name: name, iconUrl: iconUrl);
  }
}
