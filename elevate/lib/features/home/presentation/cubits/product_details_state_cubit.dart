// States
import '../../data/models/product_details_model.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsModel product;
  ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  ProductDetailsError(this.message);
}