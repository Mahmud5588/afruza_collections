part of "recommendation_bloc.dart";

enum RecommendationStatus { initial, loading, success, failure }

abstract class RecommendationEvent extends Equatable {
  const RecommendationEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecommendations extends RecommendationEvent {
  const LoadRecommendations({this.limit = 8});

  final int limit;

  @override
  List<Object?> get props => [limit];
}
