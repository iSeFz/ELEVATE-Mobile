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
      // String customerId = LocalDatabaseService.getCustomerId();
      // //put customer review above
      // ReviewModel? customerReview = getCustomerReview(customerId);
      // if(customerReview!= null) {
      //   _reviews.removeWhere((review) => review.customerId == customerId);
      //   _reviews.insert(0, customerReview);
      // }

      emit(ReviewSuccess()); // just a generic success state
    } catch (e) {
      emit(ReviewError(e.toString()+'hh'));
    }
  }

Future<void> createReview(ReviewModel review ) async {
  try {
    emit(ReviewLoading());

    String userId = LocalDatabaseService.getCustomerId();
    review.customerId = userId;
    review.customerFirstName = LocalDatabaseService.getfirstName();
    review.customerLastName = LocalDatabaseService.getLastName();
    review.customerImageURL = LocalDatabaseService.getImageURL();
    await ReviewService.createProductReview(review);
    _reviews.add(review); // Add the new review to the internal list

    emit(ReviewSuccess());
  } catch (e) {
    emit(ReviewError(e.toString()));
  }
}

  Future<void> editReview(ReviewModel review ) async {
    try {
      emit(ReviewLoading());

      String userId = LocalDatabaseService.getCustomerId();
      review.customerId = userId;
      await ReviewService.updateProductReview(review);

      emit(ReviewSuccess());
    } catch (e) {
      emit(ReviewError(e.toString()+'uuu'));
    }
  }

  ReviewModel? getCustomerReview(String customerId) {
    // Filter reviews by customerId
    final customerReview = _reviews.where((review) => review.customerId == customerId).first;
    _reviews.removeWhere((review) => review.customerId == customerId);
    return customerReview;
  }

  int canCustomerReview(String productId) {
    final customerId = LocalDatabaseService.getCustomerId();

    // If reviews list is empty, treat it as "already reviewed" (or no permission to review)
    if (_reviews.isEmpty || _reviews == null) {
      print('Reviews list is empty — blocking review');
      return 1;
    }

    final hasReviewed = _reviews.any((review) =>
    review.productId == productId && review.customerId == customerId
    );

    print('hasReviewed: $hasReviewed');
    return hasReviewed ? 0 : 1;
  }


  Future<void> deleteReview(ReviewModel review ) async {
    try {
      emit(ReviewLoading());

      String userId = LocalDatabaseService.getCustomerId();
      review.customerId = userId;
      await ReviewService.deleteProductReview(review);

      emit(ReviewSuccess());
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}



