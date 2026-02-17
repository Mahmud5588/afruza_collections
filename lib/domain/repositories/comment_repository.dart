import "../entities/comment.dart";

abstract class CommentRepository {
  /// Mahsulot uchun barcha izohlarni olish (pagination bilan)
  Future<List<Comment>> fetchComments({
    required int productId,
    int? skip,
    int? limit,
  });

  /// Yangi izoh qo'shish
  Future<void> createComment({
    required int productId,
    required String text,
  });

  /// Izohni o'chirish
  Future<void> deleteComment({
    required int productId,
    required int commentId,
  });
}
