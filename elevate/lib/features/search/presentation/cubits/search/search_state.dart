import '../../../../product_details/data/models/product_card_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}
class SearchEmpty extends SearchState {}
class SearchLoaded extends SearchState {
  final List<ProductCardModel> products;
  final List<String> brands = [];
  // Map<String, List<String>> categories = {};
  SearchLoaded({
    this.products = const [],
    brands = const [],
  });}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
