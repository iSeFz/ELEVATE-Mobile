// Cubit class
import 'package:elevate/features/home/presentation/cubits/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/review_model.dart';
import '../../data/services/review_service.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial()) {
    // TODO: implement ReviewCubit
  }

  Future<void> fetchProductReviews(String productId) async {
    try {
      emit(ReviewLoading());

      // Call static method directly
      List<ReviewModel> reviews = await ReviewService.getProductReviews(productId);

      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
