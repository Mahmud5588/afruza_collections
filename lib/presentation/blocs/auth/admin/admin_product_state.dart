part of "admin_product_bloc.dart";

class AdminProductState extends Equatable {
  const AdminProductState({
    this.status = AdminProductStatus.initial,
    this.products = const [],
    this.message,
  });

  final AdminProductStatus status;
  final List<Product> products;
  final String? message;

  AdminProductState copyWith({
    AdminProductStatus? status,
    List<Product>? products,
    String? message,
  }) {
    return AdminProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, products, message];
}
