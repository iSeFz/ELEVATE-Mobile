import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../product_details/data/models/product_card_model.dart';
import '../../../../product_details/data/services/product_service.dart';
import 'home_state.dart';

// Home Cubit
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final ProductService _productService = ProductService();
  List<ProductCardModel> _homePageProducts = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;

  List<ProductCardModel> get homePageProducts => _homePageProducts;
  bool get isLoadingMore => _isLoadingMore;

  // Retrieve a single page of products
  Future<void> fetchProductPage(int pageNumber) async {
    if (pageNumber == 1) {
      emit(HomeLoading());
      _homePageProducts.clear();
      _currentPage = 1;
    } else {
      _isLoadingMore = true;
      emit(HomeLoadingMore());
    }

    try {
      final newProducts = await _productService.getProductPage(pageNumber);

      if (pageNumber == 1) {
        _homePageProducts = newProducts;
      } else {
        _homePageProducts.addAll(newProducts);
      }

      _currentPage = pageNumber;
      _isLoadingMore = false;

      if (_homePageProducts.isNotEmpty) {
        emit(HomeLoaded());
      } else {
        emit(HomeError(message: "No products found"));
      }
    } catch (e) {
      _isLoadingMore = false;
      emit(HomeError(message: e.toString()));
    }
  }

  // Load more products when the user scrolls to the bottom
  Future<void> loadMoreProducts() async {
    if (!_isLoadingMore) {
      await fetchProductPage(_currentPage + 1);
    }
  }
}
