import "package:bloc/bloc.dart";
import "package:equatable/equatable.dart";

import "../../../domain/entities/product.dart";
import "../../../domain/usecases/get_most_sold.dart";
import "../../../domain/usecases/get_most_viewed.dart";
import "../../../data/remote/api_exception.dart";

part "recommendation_event.dart";
part "recommendation_state.dart";

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  RecommendationBloc(this._getMostViewed, this._getMostSold)
      : super(const RecommendationState()) {
    on<LoadRecommendations>(_onLoadRecommendations);
  }

  final GetMostViewed _getMostViewed;
  final GetMostSold _getMostSold;

  Future<void> _onLoadRecommendations(
    LoadRecommendations event,
    Emitter<RecommendationState> emit,
  ) async {
    emit(state.copyWith(status: RecommendationStatus.loading, message: null));
    try {
      final viewed = await _getMostViewed(limit: event.limit);
      final sold = await _getMostSold(limit: event.limit);
      emit(state.copyWith(
        status: RecommendationStatus.success,
        mostViewed: viewed,
        mostSold: sold,
      ));
    } catch (error) {
      final message = error is ApiException
          ? error.message
          : "Failed to load recommendations";
      emit(state.copyWith(status: RecommendationStatus.failure, message: message));
    }
  }
}
