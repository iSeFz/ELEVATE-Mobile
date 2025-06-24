import 'package:bloc/bloc.dart';
import 'package:elevate/features/home/data/models/product_card_model.dart';
import 'package:elevate/features/home/presentation/cubits/product_details_state.dart';
import '../../data/models/product_details_model.dart';
import '../../data/services/product_service.dart';

// Cubit class
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  Future<void> fetchProductDetials(String productId) async {
    try {
      emit(ProductDetailsLoading());

      // Call static method directly
      ProductDetailsModel product = await ProductService.getProductDetails(
        productId,
      );
      emit(
        ProductDetailsLoaded(
          product: product,
          selectedSizeId:
              product.variants.isNotEmpty ? product.variants.first.id : null,
          relatedProducts: [],
        ),
      );

      // Fetch related products after loading the main product
      fetchRelatedProducts(productId);
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  Future<void> fetchRelatedProducts(String productId) async {
    try {
      if (state is ProductDetailsLoaded) {
        List<ProductCardModel> relatedProducts =
            await ProductService.getRelatedProducts(productId);
        emit(
          (state as ProductDetailsLoaded).copyWith(
            relatedProducts: relatedProducts,
          ),
        );
      }
    } catch (e) {
      print('Error fetching related products: ${e.toString()}');
    }
  }

  String getShortSize(String size) {
    final regex = RegExp(r'^(X+)?(.*)$', caseSensitive: false);
    final match = regex.firstMatch(size);
    if (match != null) {
      final xPart = match.group(1) ?? '';
      final afterX = match.group(2)?.trim() ?? '';
      final firstLetter = afterX.isNotEmpty ? afterX[0].toUpperCase() : '';
      return '$xPart$firstLetter';
    } else {
      return size; // fallback
    }
  }

  void selectSize(String id) {
    if (state is ProductDetailsLoaded) {
      emit((state as ProductDetailsLoaded).copyWith(selectedSizeId: id));
    }
  }
}
