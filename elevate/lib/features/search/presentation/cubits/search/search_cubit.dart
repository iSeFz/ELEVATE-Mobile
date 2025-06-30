// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../product_details/data/models/product_card_model.dart';
// import '../../../../../core/services/algolia_service.dart';
// import 'search_state.dart';
//
// class SearchCubit extends Cubit<SearchState> {
//
//   SearchCubit() : super(SearchInitial());
//   AlgoliaService algoliaService = AlgoliaService();
//
//   // Future<void> searchProducts({String query = '', List<List<String>> facets = const []}) async {
//   //   emit(SearchLoading());
//   //   try {
//   //     final results = await algoliaService.searchProducts(query);
//   //
//   //     if (results.isEmpty) {  // searchProducts already guarantees a list, no need to check for null
//   //       emit(SearchEmpty());
//   //       return;
//   //     }
//   //
//   //     // Safely parse only valid JSON maps
//   //     final List<ProductCardModel> products = results
//   //         .where((json) => json != null && json is Map<String, dynamic>)
//   //         .map((json) => ProductCardModel.fromJson(json))
//   //         .toList();
//   //
//   //
//   //     emit(SearchLoaded(products: products));
//   //   } catch (e) {
//   //     emit(SearchError('Search failed: $e'));
//   //   }
//   // }
//
// }
