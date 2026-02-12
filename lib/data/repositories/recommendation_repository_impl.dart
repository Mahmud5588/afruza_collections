import "package:dio/dio.dart";

import "../../domain/entities/product.dart";
import "../../domain/repositories/recommendation_repository.dart";
import "../models/product_model.dart";
import "../remote/error_mapper.dart";

class RecommendationRepositoryImpl implements RecommendationRepository {
  RecommendationRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<Product>> fetchMostViewed({int limit = 10}) async {
    try {
      final response = await dio.get(
        "/recommendations/most-viewed",
        queryParameters: {"limit": limit},
      );
      final data = response.data as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<List<Product>> fetchMostSold({int limit = 10}) async {
    try {
      final response = await dio.get(
        "/recommendations/most-sold",
        queryParameters: {"limit": limit},
      );
      final data = response.data as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
