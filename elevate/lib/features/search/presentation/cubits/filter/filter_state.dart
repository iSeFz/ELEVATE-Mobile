import '../../../data/models/brand_model.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}
class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {
  final List<String> brandsName;
  final List<String> departments;
  final Map<String,List<String>> categories;

  FilterLoaded({required this.brandsName, required this.departments, required this.categories});
}

class FilterError extends FilterState {
  final String message;
  FilterError(this.message);
}

