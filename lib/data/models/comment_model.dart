import "../../domain/entities/comment.dart";

class CommentModel {
  CommentModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userEmail,
    required this.text,
    required this.rating,
    required this.createdAt,
  });

  final int id;
  final int productId;
  final int userId;
  final String userEmail;
  final String text;
  final double rating;
  final DateTime createdAt;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json["id"] as int,
      productId: json["product_id"] as int,
      userId: json["user_id"] as int,
      userEmail: json["user_email"] as String? ?? "User",
      text: json["text"] as String,
      rating: (json["rating"] as num?)?.toDouble() ?? 5.0,
      createdAt: DateTime.parse(json["created_at"] as String),
    );
  }

  Comment toEntity() {
    return Comment(
      id: id,
      productId: productId,
      userId: userId,
      userEmail: userEmail,
      text: text,
      rating: rating,
      createdAt: createdAt,
    );
  }
}
