import "../../domain/entities/user.dart";

class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.isAdmin,
    required this.isActive,
  });

  final int id;
  final String email;
  final bool isAdmin;
  final bool isActive;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as int,
      email: json["email"] as String,
      isAdmin: json["is_admin"] as bool? ?? false,
      isActive: json["is_active"] as bool? ?? true,
    );
  }

  UserAccount toEntity() {
    return UserAccount(
      id: id,
      email: email,
      isAdmin: isAdmin,
      isActive: isActive,
    );
  }
}
