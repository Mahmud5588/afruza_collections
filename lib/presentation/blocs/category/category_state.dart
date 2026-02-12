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
    String? message,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, categories, message];
}
