import '../../../product_details/data/models/product_card_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ProductCardModel> products;
  // final List<Map<String, dynamic>> products;
  Map<String, List<String>> categories = {};
  SearchLoaded(this.products);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
