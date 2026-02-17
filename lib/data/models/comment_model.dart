import "../../domain/entities/comment.dart";

class CommentModel {
  CommentModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  final int id;
  final int productId;
  final int userId;
  final String text;
  final DateTime createdAt;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json["id"] as int,
      productId: json["product_id"] as int,
      userId: json["user_id"] as int,
      text: json["text"] as String,
      createdAt: DateTime.parse(json["created_at"] as String),
    );
  }

  Comment toEntity() {
    return Comment(
      id: id,
      productId: productId,
      userId: userId,
      text: text,
      createdAt: createdAt,
    );
  }
}
