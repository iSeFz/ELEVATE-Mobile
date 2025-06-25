// States
import '../../data/models/product_details_model.dart';
import '../../data/models/product_card_model.dart';

abstract class ProductDetailsState {
  get selectedSizeId => null;
  get relatedProducts => null;
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsModel product;
  final String? selectedSizeId;
  final List<ProductCardModel>? relatedProducts;

  ProductDetailsLoaded({
    required this.product,
    this.selectedSizeId,
    this.relatedProducts,
  });

  ProductDetailsLoaded copyWith({
    ProductDetailsModel? product,
    String? selectedSizeId,
    List<ProductCardModel>? relatedProducts,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      selectedSizeId: selectedSizeId ?? this.selectedSizeId,
      relatedProducts: relatedProducts ?? this.relatedProducts,
    );
  }
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  ProductDetailsError(this.message);
}
