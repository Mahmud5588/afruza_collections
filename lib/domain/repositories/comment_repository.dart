import "../entities/comment.dart";

abstract class CommentRepository {
  /// Mahsulot uchun barcha izohlarni olish
  Future<List<Comment>> fetchComments({required int productId});

  /// Yangi izoh qo'shish
  Future<void> createComment({
    required int productId,
    required String text,
    required double rating,
  });

  /// Izohni o'chirish
  Future<void> deleteComment({required int commentId});
}
