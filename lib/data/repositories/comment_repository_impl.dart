import "package:dio/dio.dart";

import "../../domain/entities/comment.dart";
import "../../domain/repositories/comment_repository.dart";
import "../models/comment_model.dart";
import "../remote/error_mapper.dart";

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<Comment>> fetchComments({
    required int productId,
    int? skip,
    int? limit,
  }) async {
    try {
      final response = await dio.get(
        "/products/$productId/comments",
        queryParameters: {
          if (skip != null) "skip": skip,
          if (limit != null) "limit": limit,
        },
      );
      // Backend paginatedresponse qaytarmoqda
      final payload = response.data;
      final List<dynamic> data;

      // Check if response is paginated or direct list
      if (payload is Map<String, dynamic> && payload.containsKey('items')) {
        data = payload["items"] as List<dynamic>? ?? [];
      } else if (payload is List) {
        data = payload;
      } else {
        data = [];
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(CommentModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> createComment({
    required int productId,
    required String text,
  }) async {
    try {
      await dio.post(
        "/products/$productId/comments",
        data: {
          "text": text,
        },
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> deleteComment({
    required int productId,
    required int commentId,
  }) async {
    try {
      await dio.delete("/products/$productId/comments/$commentId");
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
