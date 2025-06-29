import 'package:elevate/features/product_details/data/services/product_service.dart';
import 'package:elevate/features/search/presentation/cubits/search/search_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/algolia_service.dart' show AlgoliaService;
import '../../../data/models/brand_model.dart';
import '../../../data/services/brand_service.dart';
import 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());
  final SearchCubit searchCubit = SearchCubit();
  final AlgoliaService algoliaService = AlgoliaService();

  static List<String> _brandsNames = [];
  List<String> get brandsNames => List.unmodifiable(_brandsNames);


  static List<String> _departments = [];
  List<String> get departments => List.unmodifiable(_departments);

  List<String> _categories= [];
  List<String> get categories => List.unmodifiable(_categories);


  // selected lists
  List<String> _selectedCateg = [];
  List<String> get selectedCateg => _selectedCateg;

  List<String> _selectedDep = [];
  List<String> get selectedDep => _selectedDep;

  List<String> _selectedBrands = [];
  List<String> get selectedBrands => _selectedBrands;



  Future<void> getAllBrands() async {
    emit(FilterLoading());
    try {
      _brandsNames.clear();
      _brandsNames = await algoliaService.getAllBrandNames();
      emit(FilterLoaded());
    } catch (e) {
      emit(FilterError(e.toString()));
      rethrow;
    }
  }

  Future<void> getAllDepartments() async {
    emit(FilterLoading());
    try {
      _departments.clear();
      _departments = await ProductService.getAllDepartments();
      emit(FilterLoaded());
    } catch (e) {
      emit(FilterError(e.toString()));
      rethrow;
    }
  }

  Future<void> getAllCategories() async {
    emit(FilterLoading());
    try {
      _categories.clear();
      _categories = await ProductService.getAllCategories();
      emit(FilterLoaded());
    } catch (e) {
      emit(FilterError(e.toString()));
      rethrow;
    }
  }


  void updateSelectedBrands(List<String> selectedBrands) async {
    _selectedBrands.clear();
    _selectedBrands = List.from(selectedBrands);
    algoliaService.addFacets(_selectedBrands, 'brandName');

  }

  void updateSelectedDep(List<String> selectedDep) async {
    _selectedDep.clear();
    _selectedDep = List.from(selectedDep);
    algoliaService.addFacets(selectedDep, 'department');

    // Example: you can now use formattedBrands in your filters
    // print(formattedBrands);
  }
  void updateSelectedCateg(List<String> selectedCateg) async {
    _selectedCateg.clear();
    _selectedCateg = List.from(selectedCateg);
    algoliaService.addFacets(selectedCateg, 'category');
    print('Selected Categories: $_selectedCateg');
  }
}