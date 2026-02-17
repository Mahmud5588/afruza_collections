import "../entities/category.dart";
import "../entities/paged_result.dart";

abstract class CategoryRepository {
  Future<PagedResult<Category>> fetchCategories({int? skip, int? limit});
  Future<void> createCategory({required String name, String? iconUrl});
  Future<void> createCategoryWithIcon({required String name, String? iconPath});
  Future<void> updateCategory(
      {required int categoryId, required String name, String? iconUrl});
  Future<void> deleteCategory({required int categoryId});
}
