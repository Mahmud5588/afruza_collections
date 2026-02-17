import "dart:io";

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
  Future<void> createCategory({required String name, String? iconUrl}) async {
    try {
      final data = {"name": name};
      if (iconUrl != null) {
        data["icon_url"] = iconUrl;
      }
      await dio.post("/categories", data: data);
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> createCategoryWithIcon(
      {required String name, String? iconPath}) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry("name", name));

      if (iconPath != null && File(iconPath).existsSync()) {
        formData.files.add(
          MapEntry(
            "icon",
            await MultipartFile.fromFile(iconPath),
          ),
        );
      }

      await dio.post("/categories/with-icon", data: formData);
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> updateCategory(
      {required int categoryId, required String name, String? iconUrl}) async {
    try {
      final data = {"name": name};
      if (iconUrl != null) {
        data["icon_url"] = iconUrl;
      }
      await dio.put("/categories/$categoryId", data: data);
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
