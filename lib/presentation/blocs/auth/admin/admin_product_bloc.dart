import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../../../../domain/entities/product.dart";
import "../../../../domain/usecases/create_product.dart";
import "../../../../domain/usecases/create_product_with_image.dart";
import "../../../../domain/usecases/delete_product.dart";
import "../../../../domain/usecases/get_products.dart";
import "../../../../domain/usecases/update_product.dart";
import "../../../../data/remote/api_exception.dart";

part "admin_product_event.dart";
part "admin_product_state.dart";

class AdminProductBloc extends Bloc<AdminProductEvent, AdminProductState> {
  AdminProductBloc(
    this._getProducts,
    this._createProduct,
    this._createProductWithImage,
    this._deleteProduct,
    this._updateProduct,
  ) : super(const AdminProductState()) {
    on<LoadAdminProducts>(_onLoadProducts);
    on<CreateAdminProduct>(_onCreateProduct);
    on<DeleteAdminProduct>(_onDeleteProduct);
    on<UpdateAdminProduct>(_onUpdateProduct);
  }

  final GetProducts _getProducts;
  final CreateProduct _createProduct;
  final CreateProductWithImage _createProductWithImage;
  final DeleteProduct _deleteProduct;
  final UpdateProduct _updateProduct;

  Future<void> _onLoadProducts(
    LoadAdminProducts event,
    Emitter<AdminProductState> emit,
  ) async {
    emit(state.copyWith(status: AdminProductStatus.loading, message: null));
    try {
      final result = await _getProducts();
      emit(state.copyWith(
          status: AdminProductStatus.success, products: result.items));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load products";
      emit(
          state.copyWith(status: AdminProductStatus.failure, message: message));
    }
  }

  Future<void> _onCreateProduct(
    CreateAdminProduct event,
    Emitter<AdminProductState> emit,
  ) async {
    emit(state.copyWith(status: AdminProductStatus.loading, message: null));
    try {
      // Agar birinchi rasm file path (lokal) bo'lsa, createProductWithImage ishlatamiz
      final hasLocalImage = event.images.isNotEmpty &&
          !event.images.first.startsWith("http://") &&
          !event.images.first.startsWith("https://");

      if (hasLocalImage) {
        // Backend /products/with-image endpoint faqat bitta rasm qabul qiladi
        await _createProductWithImage(
          name: event.name,
          description: event.description,
          price: event.price,
          categoryId: event.categoryId,
          imagePath: event.images.first,
          rating: event.rating,
          variants: event.variants.isEmpty ? null : event.variants,
        );
      } else {
        // URL images bo'lsa oddiy create ishlatamiz
        await _createProduct(
          name: event.name,
          description: event.description,
          price: event.price,
          rating: event.rating,
          categoryId: event.categoryId,
          images: event.images,
          variants: event.variants,
        );
      }

      final result = await _getProducts();
      emit(state.copyWith(
          status: AdminProductStatus.success, products: result.items));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to create product";
      emit(
          state.copyWith(status: AdminProductStatus.failure, message: message));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteAdminProduct event,
    Emitter<AdminProductState> emit,
  ) async {
    emit(state.copyWith(status: AdminProductStatus.loading, message: null));
    try {
      await _deleteProduct(productId: event.productId);
      final result = await _getProducts();
      emit(state.copyWith(
          status: AdminProductStatus.success, products: result.items));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to delete product";
      emit(
          state.copyWith(status: AdminProductStatus.failure, message: message));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateAdminProduct event,
    Emitter<AdminProductState> emit,
  ) async {
    emit(state.copyWith(status: AdminProductStatus.loading, message: null));
    try {
      await _updateProduct(
        productId: event.productId,
        name: event.name,
        description: event.description,
        price: event.price,
        rating: event.rating,
        categoryId: event.categoryId,
        images: event.images,
        variants: event.variants,
      );
      final result = await _getProducts();
      emit(state.copyWith(
          status: AdminProductStatus.success, products: result.items));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to update product";
      emit(
          state.copyWith(status: AdminProductStatus.failure, message: message));
    }
  }
}
