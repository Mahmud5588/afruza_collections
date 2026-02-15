part of "admin_category_bloc.dart";

enum AdminCategoryStatus { initial, loading, success, failure }

abstract class AdminCategoryEvent extends Equatable {
  const AdminCategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminCategories extends AdminCategoryEvent {
  const LoadAdminCategories({this.skip, this.limit});

  final int? skip;
  final int? limit;

  @override
  List<Object?> get props => [skip, limit];
}

class LoadMoreAdminCategories extends AdminCategoryEvent {
  const LoadMoreAdminCategories();
}

class CreateAdminCategory extends AdminCategoryEvent {
  const CreateAdminCategory({required this.name, this.iconUrl});

  final String name;
  final String? iconUrl;

  @override
  List<Object?> get props => [name, iconUrl];
}

class DeleteAdminCategory extends AdminCategoryEvent {
  const DeleteAdminCategory({required this.categoryId});

  final int categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class UpdateAdminCategory extends AdminCategoryEvent {
  const UpdateAdminCategory(
      {required this.categoryId, required this.name, this.iconUrl});

  final int categoryId;
  final String name;
  final String? iconUrl;

  @override
  List<Object?> get props => [categoryId, name, iconUrl];
}
