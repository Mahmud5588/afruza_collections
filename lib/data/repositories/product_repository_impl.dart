import "dart:io";

import "package:dio/dio.dart";

import "../../domain/entities/paged_result.dart";
import "../../domain/entities/product.dart";
import "../../domain/repositories/product_repository.dart";
import "../models/product_model.dart";
import "../remote/error_mapper.dart";

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<PagedResult<Product>> fetchProducts({
    String? query,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    int? skip,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        "/products/paged",
        queryParameters: {
          if (query != null && query.isNotEmpty) "q": query,
          if (categoryId != null) "category_id": categoryId,
          if (minPrice != null) "price_min": minPrice,
          if (maxPrice != null) "price_max": maxPrice,
          if (skip != null) "skip": skip,
          if (limit != null) "limit": limit,
        },
      );
      final payload = response.data as Map<String, dynamic>;
      final data = payload["items"] as List<dynamic>? ?? [];
      final items = data
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
      return PagedResult<Product>(
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
  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required double rating,
    required int categoryId,
    required List<String> images,
    required List<Map<String, dynamic>> variants,
  }) async {
    try {
      await dio.post(
        "/products",
        data: {
          "name": name,
          "description": description,
          "price": price,
          "rating": rating,
          "category_id": categoryId,
          "images": images, // Backend oddiy string array qabul qiladi
          "variants": variants,
        },
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> updateProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    required double rating,
    required int categoryId,
    required List<String> images,
    required List<Map<String, dynamic>> variants,
  }) async {
    try {
      await dio.put(
        "/products/$productId",
        data: {
          "name": name,
          "description": description,
          "price": price,
          "rating": rating,
          "category_id": categoryId,
          "images": images, // Backend oddiy string array qabul qiladi
          "variants": variants,
        },
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> createProductWithImage({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    required String imagePath,
    double rating = 0,
    List<Map<String, dynamic>>? variants,
  }) async {
    try {
      final formData = FormData();
      formData.fields.addAll([
        MapEntry("name", name),
        MapEntry("description", description),
        MapEntry("price", price.toString()),
        MapEntry("rating", rating.toString()),
        MapEntry("category_id", categoryId.toString()),
      ]);

      if (File(imagePath).existsSync()) {
        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(imagePath),
          ),
        );
      }

      if (variants != null && variants.isNotEmpty) {
        for (int i = 0; i < variants.length; i++) {
          final variant = variants[i];
          formData.fields.add(
            MapEntry("variants[$i][name]", variant["name"].toString()),
          );
          formData.fields.add(
            MapEntry("variants[$i][price]", variant["price"].toString()),
          );
        }
      }

      await dio.post("/products/with-image", data: formData);
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> deleteProduct({required int productId}) async {
    try {
      await dio.delete("/products/$productId");
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
