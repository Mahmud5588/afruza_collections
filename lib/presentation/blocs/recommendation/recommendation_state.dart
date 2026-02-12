part of "recommendation_bloc.dart";

class RecommendationState extends Equatable {
  const RecommendationState({
    this.status = RecommendationStatus.initial,
    this.mostViewed = const [],
    this.mostSold = const [],
    this.message,
  });

  final RecommendationStatus status;
  final List<Product> mostViewed;
  final List<Product> mostSold;
  final String? message;

  RecommendationState copyWith({
    RecommendationStatus? status,
    List<Product>? mostViewed,
    List<Product>? mostSold,
    String? message,
  }) {
    return RecommendationState(
      status: status ?? this.status,
      mostViewed: mostViewed ?? this.mostViewed,
      mostSold: mostSold ?? this.mostSold,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, mostViewed, mostSold, message];
}
