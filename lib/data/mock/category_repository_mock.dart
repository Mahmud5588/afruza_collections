import "../../core/app_config.dart";
import "../../domain/entities/category.dart";
import "../../domain/entities/paged_result.dart";
import "../../domain/repositories/category_repository.dart";
import "mock_data_source.dart";

/// Mock Category Repository - Backend tayyor bo'lgunicha test qilish uchun
class CategoryRepositoryMock implements CategoryRepository {
  static final List<Category> _categories =
      List.from(MockDataSource.categories);

  @override
  Future<PagedResult<Category>> fetchCategories({int? skip, int? limit}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    final skipValue = skip ?? 0;
    final limitValue = limit ?? _categories.length;

    final items = _categories.skip(skipValue).take(limitValue).toList();
    final nextSkip = skipValue + limitValue < _categories.length
        ? skipValue + limitValue
        : null;

    return PagedResult<Category>(
      items: items,
      total: _categories.length,
      skip: skipValue,
      limit: limitValue,
      nextSkip: nextSkip,
    );
  }

  @override
  Future<void> createCategory({required String name, String? iconUrl}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    final newId = _categories.isEmpty
        ? 1
        : _categories.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;

    _categories.add(Category(id: newId, name: name, icon: iconUrl));
  }

  @override
  Future<void> updateCategory(
      {required int categoryId, required String name, String? iconUrl}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index == -1) {
      throw Exception("Kategoriya topilmadi!");
    }

    final oldCategory = _categories[index];
    _categories[index] =
        Category(id: categoryId, name: name, icon: iconUrl ?? oldCategory.icon);
  }

  @override
  Future<void> deleteCategory({required int categoryId}) async {
    if (!AppConfig.useMockData) {
      throw Exception("Mock mode o'chirilgan!");
    }

    // Mock delay
    await Future.delayed(const Duration(milliseconds: 300));

    _categories.removeWhere((c) => c.id == categoryId);
  }
}
