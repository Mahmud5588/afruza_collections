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
    Object? message = _undefined,
  }) {
    return AdminProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message == _undefined ? this.message : message as String?,
    );
  }

  @override
  List<Object?> get props => [status, products, message];
}

const _undefined = Object();
