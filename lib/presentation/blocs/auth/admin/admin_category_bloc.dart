import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../../../../domain/entities/category.dart";
import "../../../../domain/usecases/create_category.dart";
import "../../../../domain/usecases/delete_category.dart";
import "../../../../domain/usecases/get_categories.dart";
import "../../../../domain/usecases/update_category.dart";
import "../../../../data/remote/api_exception.dart";

part "admin_category_event.dart";
part "admin_category_state.dart";

class AdminCategoryBloc extends Bloc<AdminCategoryEvent, AdminCategoryState> {
  AdminCategoryBloc(this._getCategories, this._createCategory,
      this._deleteCategory, this._updateCategory)
      : super(const AdminCategoryState()) {
    on<LoadAdminCategories>(_onLoadCategories);
    on<LoadMoreAdminCategories>(_onLoadMoreCategories);
    on<CreateAdminCategory>(_onCreateCategory);
    on<DeleteAdminCategory>(_onDeleteCategory);
    on<UpdateAdminCategory>(_onUpdateCategory);
  }

  final GetCategories _getCategories;
  final CreateCategory _createCategory;
  final DeleteCategory _deleteCategory;
  final UpdateCategory _updateCategory;
  static const int _pageSize = 30;

  Future<void> _onLoadCategories(
    LoadAdminCategories event,
    Emitter<AdminCategoryState> emit,
  ) async {
    emit(state.copyWith(
      status: AdminCategoryStatus.loading,
      categories: const [],
      isLoadingMore: false,
      hasReachedMax: false,
      message: null,
    ));
    try {
      final result = await _getCategories(
        skip: event.skip ?? 0,
        limit: event.limit ?? _pageSize,
      );
      final categories = result.items;
      final reachedMax = result.nextSkip == null;
      emit(state.copyWith(
          status: AdminCategoryStatus.success,
          categories: categories,
          hasReachedMax: reachedMax));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load categories";
      emit(state.copyWith(
          status: AdminCategoryStatus.failure, message: message));
    }
  }

  Future<void> _onLoadMoreCategories(
    LoadMoreAdminCategories event,
    Emitter<AdminCategoryState> emit,
  ) async {
    if (state.isLoadingMore || state.hasReachedMax) {
      return;
    }
    if (state.status != AdminCategoryStatus.success) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    try {
      final result = await _getCategories(
        skip: state.categories.length,
        limit: _pageSize,
      );
      final categories = result.items;
      if (categories.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasReachedMax: true));
        return;
      }
      emit(state.copyWith(
        categories: [...state.categories, ...categories],
        isLoadingMore: false,
        hasReachedMax: result.nextSkip == null,
      ));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load categories";
      emit(state.copyWith(isLoadingMore: false, message: message));
    }
  }

  Future<void> _onCreateCategory(
    CreateAdminCategory event,
    Emitter<AdminCategoryState> emit,
  ) async {
    emit(state.copyWith(status: AdminCategoryStatus.loading, message: null));
    try {
      await _createCategory(name: event.name, iconUrl: event.iconUrl);
      final result = await _getCategories(limit: _pageSize);
      emit(state.copyWith(
          status: AdminCategoryStatus.success, categories: result.items));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to create category";
      emit(state.copyWith(
          status: AdminCategoryStatus.failure, message: message));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteAdminCategory event,
    Emitter<AdminCategoryState> emit,
  ) async {
    emit(state.copyWith(status: AdminCategoryStatus.loading, message: null));
    try {
      await _deleteCategory(categoryId: event.categoryId);
      final result = await _getCategories(limit: _pageSize);
      emit(state.copyWith(
          status: AdminCategoryStatus.success, categories: result.items));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to delete category";
      emit(state.copyWith(
          status: AdminCategoryStatus.failure, message: message));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateAdminCategory event,
    Emitter<AdminCategoryState> emit,
  ) async {
    emit(state.copyWith(status: AdminCategoryStatus.loading, message: null));
    try {
      await _updateCategory(
          categoryId: event.categoryId,
          name: event.name,
          iconUrl: event.iconUrl);
      final result = await _getCategories(limit: _pageSize);
      emit(state.copyWith(
          status: AdminCategoryStatus.success, categories: result.items));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to update category";
      emit(state.copyWith(
          status: AdminCategoryStatus.failure, message: message));
    }
  }
}
