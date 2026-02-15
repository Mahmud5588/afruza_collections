class Comment {
  final int id;
  final int productId;
  final int userId;
  final String userEmail;
  final String text;
  final double rating;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userEmail,
    required this.text,
    required this.rating,
    required this.createdAt,
  });
}
