class Comment {
  final int id;
  final int productId;
  final int userId;
  final String text;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.productId,
    required this.userId,
    required this.text,
    required this.createdAt,
  });
}
