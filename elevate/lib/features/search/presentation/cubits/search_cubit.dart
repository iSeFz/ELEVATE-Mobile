import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../product_details/data/models/product_card_model.dart';
import '../../../../core/services/algolia_service.dart';
import '../../data/services/filters_service.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {

  SearchCubit() : super(SearchInitial());

  get products => null;

  Future<void> searchProducts(String query) async {
    emit(SearchLoading());
    try {
      final results = await AlgoliaService.searchProducts(query);
      final List<ProductCardModel>products = results.map((json) => ProductCardModel.fromJson(json)).toList();
      // emit(SearchLoaded(results));
      emit(SearchLoaded(products));

    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
  Future<Map<String, List<String>>> getAllCategories() async {
    emit(SearchLoading());
    try {
      final results = await FilterService.getAllProductsCategories();
      // emit(SearchLoaded(results)); // Uncomment if you want to emit this state
      return results;
    } catch (e) {
      emit(SearchError(e.toString()));
      rethrow;
    }
  }
}
