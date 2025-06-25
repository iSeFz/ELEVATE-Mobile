// Cubit class
import 'package:elevate/core/services/local_database_service.dart';
import 'package:elevate/features/product_details/presentation/cubits/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/data/models/customer.dart';
import '../../data/models/review_model.dart';
import '../../data/services/review_service.dart';
class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  // Private list to store reviews internally
  final List<ReviewModel> _reviews = [];

  // Public getter to access reviews
  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  Future<void> fetchProductReviews(String productId) async {
    try {
      emit(ReviewLoading());

      final fetchedReviews = await ReviewService.getProductReviews(productId);
      _reviews.clear();
      _reviews.addAll(fetchedReviews);

      emit(ReviewSuccess()); // just a generic success state
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
  // Future<void> submitReview(ReviewModel review) async {
  //   try {
  //     emit(ReviewLoading());
  //
  //     // Assuming you have productId and userId inside review object
  //     final productId = review.productId;
  //     final userId = LocalDatabaseService.getCustomerId(); // or from review.customerId
  //
  //     await ReviewService.createProductReview(review);
  //
  //     emit(ReviewSuccess());
  //   } catch (e) {
  //     emit(ReviewError(e.toString()));
  //   }
  // }


Future<void> createReview(ReviewModel review ) async {
  try {
    emit(ReviewLoading());

    String userId = LocalDatabaseService.getCustomerId();
    review.customerId = userId;
    await ReviewService.createProductReview(review);

    emit(ReviewSuccess());
  } catch (e) {
    emit(ReviewError(e.toString()));
  }
}

  // Future<void> editReview(ReviewModel review ) async {
  //   try {
  //     emit(ReviewLoading());
  //
  //     String userId = LocalDatabaseService.getCustomerId();
  //     review.customerId = userId;
  //     await ReviewService.createProductReview(review);
  //
  //     emit(ReviewSuccess());
  //   } catch (e) {
  //     emit(ReviewError(e.toString()));
  //   }
  // }

  // Future<void> deleteReview(ReviewModel review ) async {
  //   try {
  //     emit(ReviewLoading());
  //
  //     String userId = LocalDatabaseService.getCustomerId();
  //     review.customerId = userId;
  //     await ReviewService.createProductReview(review);
  //
  //     emit(ReviewSuccess());
  //   } catch (e) {
  //     emit(ReviewError(e.toString()));
  //   }
  // }
}



