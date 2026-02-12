part of "admin_category_bloc.dart";

class AdminCategoryState extends Equatable {
  const AdminCategoryState({
    this.status = AdminCategoryStatus.initial,
    this.categories = const [],
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.message,
  });

  final AdminCategoryStatus status;
  final List<Category> categories;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? message;

  AdminCategoryState copyWith({
    AdminCategoryStatus? status,
    List<Category>? categories,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? message,
  }) {
    return AdminCategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, categories, isLoadingMore, hasReachedMax, message];
}
