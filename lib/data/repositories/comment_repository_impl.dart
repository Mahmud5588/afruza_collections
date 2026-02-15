import "package:dio/dio.dart";

import "../../domain/entities/comment.dart";
import "../../domain/repositories/comment_repository.dart";
import "../models/comment_model.dart";
import "../remote/error_mapper.dart";

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<List<Comment>> fetchComments({required int productId}) async {
    try {
      final response = await dio.get("/products/$productId/comments");
      final data = response.data as List<dynamic>;
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
    required double rating,
  }) async {
    try {
      await dio.post(
        "/products/$productId/comments",
        data: {
          "text": text,
          "rating": rating,
        },
      );
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }

  @override
  Future<void> deleteComment({required int commentId}) async {
    try {
      await dio.delete("/comments/$commentId");
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
