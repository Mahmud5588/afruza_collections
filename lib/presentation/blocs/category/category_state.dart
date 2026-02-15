part of "category_bloc.dart";

class CategoryState extends Equatable {
  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.message,
  });

  final CategoryStatus status;
  final List<Category> categories;
  final String? message;

  CategoryState copyWith({
    CategoryStatus? status,
    List<Category>? categories,
    Object? message = _undefined,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      message: message == _undefined ? this.message : message as String?,
    );
  }

  @override
  List<Object?> get props => [status, categories, message];
}

const _undefined = Object();
