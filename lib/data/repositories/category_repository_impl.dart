import "package:dio/dio.dart";

import "../../domain/entities/category.dart";
import "../../domain/entities/paged_result.dart";
import "../../domain/repositories/category_repository.dart";
import "../models/category_model.dart";
import "../remote/error_mapper.dart";

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<PagedResult<Category>> fetchCategories({int? skip, int? limit}) async {
    try {
      final response = await dio.get(
        "/categories/paged",
        queryParameters: {
          if (skip != null) "skip": skip,
          if (limit != null) "limit": limit,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final data = payload["items"] as List<dynamic>? ?? [];
      final items = data
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
      return PagedResult<Category>(
        items: items,
        total: payload["total"] as int? ?? items.length,
        skip: payload["skip"] as int? ?? (skip ?? 0),
        limit: payload["limit"] as int? ?? (limit ?? items.length),
        nextSkip: payload["next_skip"] as int?,
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> createCategory({required String name}) async {
    try {
      await dio.post("/categories", data: {"name": name});
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> updateCategory({required int categoryId, required String name}) async {
    try {
      await dio.put("/categories/$categoryId", data: {"name": name});
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> deleteCategory({required int categoryId}) async {
    try {
      await dio.delete("/categories/$categoryId");
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
