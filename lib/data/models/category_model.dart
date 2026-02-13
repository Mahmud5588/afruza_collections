import "../../domain/entities/category.dart";

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
  });

  final int id;
  final String name;
  final String? icon;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"] as int,
      name: json["name"] as String,
      icon: json["icon_url"] as String?, // API uses icon_url
    );
  }

  Category toEntity() => Category(id: id, name: name, icon: icon);
}
