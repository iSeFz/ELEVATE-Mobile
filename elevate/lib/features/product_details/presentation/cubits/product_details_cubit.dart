import 'package:bloc/bloc.dart';
import 'package:elevate/features/product_details/data/models/product_card_model.dart';
import 'package:elevate/features/product_details/presentation/cubits/product_details_state.dart';
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



  void selectSize(String id) {
    if (state is ProductDetailsLoaded) {
      emit((state as ProductDetailsLoaded).copyWith(selectedSizeId: id));
    }
  }
}
