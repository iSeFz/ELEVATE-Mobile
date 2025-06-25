// Cubit class
import 'package:elevate/core/services/local_database_service.dart';
import 'package:elevate/features/product_details/presentation/cubits/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/data/models/customer.dart';
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
      List<ReviewModel> reviews = await ReviewService.getProductReviews(
          productId);

      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
  Future<void> createReview({
    required String productId,
    required String title,
    required String content,
    required int rating,
  }) async {
    try {
      emit(ReviewLoading());

      final String userId = LocalDatabaseService.getCustomerId();

      ReviewModel review = ReviewModel(
        // productId: productId,
        // customerId: userId,
        // customerFirstName: LocalDatabaseService.getfirstName(),
        // customerLastName: LocalDatabaseService.getLastName(),
        // customerImageURL: LocalDatabaseService.getImageURL(),
        title: title,
        content: content,
        rating: rating,
      );
      await ReviewService.createProductReview(review, productId);
      // await fetchProductReviews(productId);
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }



}
