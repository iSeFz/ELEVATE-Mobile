import 'package:bloc/bloc.dart';
import 'package:elevate/features/home/data/models/product_card_model.dart';
import 'package:elevate/features/home/presentation/cubits/product_details_state_cubit.dart';
import '../../data/models/product_details_model.dart';
import '../../data/services/product_service.dart';



// Cubit class
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  Future<void> fetchProductDetials( String productId) async {
    try {
      emit(ProductDetailsLoading());

      // Call static method directly
      ProductDetailsModel product = await ProductService.getProductDetails(productId);

      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }
}
