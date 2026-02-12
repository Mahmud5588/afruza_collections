part of "category_bloc.dart";

enum CategoryStatus { initial, loading, success, failure }

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}
