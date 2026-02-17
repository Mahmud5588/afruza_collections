import "../../domain/entities/comment.dart";
import "../../domain/repositories/comment_repository.dart";

/// Mock Comment Repository - Backend tayyor bo'lgunicha test qilish uchun
class CommentRepositoryMock implements CommentRepository {
  // Mock data: Har bir mahsulot uchun namuna izohlar
  static final Map<int, List<Comment>> _comments = {
    1: [
      Comment(
        id: 1,
        productId: 1,
        userId: 1,
        text: "Juda sifatli mahsulot! Tavsiya qilaman.",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Comment(
        id: 2,
        productId: 1,
        userId: 2,
        text: "Yaxshi, lekin biroz qimmat.",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  };

  @override
  Future<List<Comment>> fetchComments({
    required int productId,
    int? skip,
    int? limit,
  }) async {
    // Mock delay
    await Future.delayed(const Duration(milliseconds: 500));
    final comments = _comments[productId] ?? [];
    final skipValue = skip ?? 0;
    final limitValue = limit ?? comments.length;
    return comments.skip(skipValue).take(limitValue).toList();
  }

  @override
  Future<void> createComment({
    required int productId,
    required String text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      productId: productId,
      userId: 999, // Mock user
      text: text,
      createdAt: DateTime.now(),
    );

    if (_comments[productId] == null) {
      _comments[productId] = [];
    }
    _comments[productId]!.add(newComment);
  }

  @override
  Future<void> deleteComment({
    required int productId,
    required int commentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation
    _comments[productId]?.removeWhere((c) => c.id == commentId);
  }
}
