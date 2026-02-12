part of "admin_product_bloc.dart";

enum AdminProductStatus { initial, loading, success, failure }

abstract class AdminProductEvent extends Equatable {
  const AdminProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminProducts extends AdminProductEvent {
  const LoadAdminProducts();
}

class CreateAdminProduct extends AdminProductEvent {
  const CreateAdminProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryId,
    required this.images,
    required this.variants,
  });

  final String name;
  final String description;
  final double price;
  final double rating;
  final int categoryId;
  final List<String> images;
  final List<Map<String, dynamic>> variants;

  @override
  List<Object?> get props =>
      [name, description, price, rating, categoryId, images, variants];
}

class DeleteAdminProduct extends AdminProductEvent {
  const DeleteAdminProduct({required this.productId});

  final int productId;

  @override
  List<Object?> get props => [productId];
}

class UpdateAdminProduct extends AdminProductEvent {
  const UpdateAdminProduct({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryId,
    required this.images,
    required this.variants,
  });

  final int productId;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int categoryId;
  final List<String> images;
  final List<Map<String, dynamic>> variants;

  @override
  List<Object?> get props => [
        productId,
        name,
        description,
        price,
        rating,
        categoryId,
        images,
        variants
      ];
}
