import '../../../data/models/brand_model.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}
class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {
  final List<String> brandsName;
  final List<String> departments;
  final Map<String, List<String>> categories;

  final List<String> selectedBrands; // Brands & Departments
  final List<String> selectedDep; // Brands & Departments
  final List<String> selectedCateg; // Categories

  FilterLoaded({
    required this.brandsName,
    required this.departments,
    required this.categories,
    this.selectedBrands = const [],
    this.selectedDep = const [],
    this.selectedCateg = const [],
  });
}

class FilterError extends FilterState {
  final String message;
  FilterError(this.message);
}

