// States
import '../../data/models/product_details_model.dart';

abstract class ProductDetailsState {
  get selectedSizeId => null;
}

class ProductDetailsInitial extends ProductDetailsState {}
class ProductDetailsLoading extends ProductDetailsState {}


class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsModel product;
  final String? selectedSizeId;

  ProductDetailsLoaded({
    required this.product,
    this.selectedSizeId,
  });

  ProductDetailsLoaded copyWith({
    ProductDetailsModel? product,
    String? selectedSizeId,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      selectedSizeId: selectedSizeId ?? this.selectedSizeId,
    );
  }
}


class ProductDetailsError extends ProductDetailsState {
  final String message;
  ProductDetailsError(this.message);
}