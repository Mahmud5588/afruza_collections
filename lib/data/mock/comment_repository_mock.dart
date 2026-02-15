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
        userEmail: "user1@test.uz",
        text: "Juda sifatli mahsulot! Tavsiya qilaman.",
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Comment(
        id: 2,
        productId: 1,
        userId: 2,
        userEmail: "user2@test.uz",
        text: "Yaxshi, lekin biroz qimmat.",
        rating: 4.0,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  };

  @override
  Future<List<Comment>> fetchComments({required int productId}) async {
    // Mock delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _comments[productId] ?? [];
  }

  @override
  Future<void> createComment({
    required int productId,
    required String text,
    required double rating,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      productId: productId,
      userId: 999, // Mock user
      userEmail: "me@test.uz",
      text: text,
      rating: rating,
      createdAt: DateTime.now(),
    );

    if (_comments[productId] == null) {
      _comments[productId] = [];
    }
    _comments[productId]!.add(newComment);
  }

  @override
  Future<void> deleteComment({required int commentId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation
  }
}
