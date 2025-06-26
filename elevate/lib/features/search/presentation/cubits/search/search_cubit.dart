import 'package:elevate/features/product_details/data/services/product_service.dart';
import 'package:elevate/features/search/data/models/brand_model.dart';
import 'package:elevate/features/search/data/services/brand_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../product_details/data/models/product_card_model.dart';
import '../../../../../core/services/algolia_service.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {

  SearchCubit() : super(SearchInitial());

  // List<ProductCardModel> _products= [];
  // get products => List.unmodifiable(_products);
  // List<String> _brandsName = [];
  // get brands => List.unmodifiable(_brandsName);
  //
  // List<String> _categories = [];
  // get categories => List.unmodifiable(_categories);


  Future<void> searchProducts(String query) async {
    emit(SearchLoading());
    try {
      final results = await AlgoliaService.searchProducts(query);
      final List<ProductCardModel>products = results.map((json) => ProductCardModel.fromJson(json)).toList();
      emit(SearchLoaded(products: products));

    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
  // Future<Map<String, List<String>>> getAllCategories() async {
  //   emit(SearchLoading());
  //   try {
  //     final results = await ProductService.getAllCategories();
  //     // emit(SearchLoaded(results)); // Uncomment if you want to emit this state
  //     return results;
  //   } catch (e) {
  //     emit(SearchError(e.toString()));
  //     rethrow;
  //   }
  // }

}
