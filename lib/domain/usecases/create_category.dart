import "../repositories/category_repository.dart";

class CreateCategory {
  const CreateCategory(this.repository);

  final CategoryRepository repository;

  Future<void> call({required String name, String? iconUrl}) {
    return repository.createCategory(name: name, iconUrl: iconUrl);
  }
}
