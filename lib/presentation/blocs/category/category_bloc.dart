import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../../../domain/entities/category.dart";
import "../../../domain/usecases/get_categories.dart";
import "../../../data/remote/api_exception.dart";

part "category_event.dart";
part "category_state.dart";

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(this._getCategories) : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
  }

  final GetCategories _getCategories;

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading, message: null));
    try {
      final result = await _getCategories();
      emit(state.copyWith(status: CategoryStatus.success, categories: result.items));
    } catch (error) {
      final message =
          error is ApiException ? error.message : "Failed to load categories";
      emit(state.copyWith(status: CategoryStatus.failure, message: message));
    }
  }
}
