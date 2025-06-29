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
    _selectedBrands = List.from(selectedBrands); // ✔ make a full copy, not a reference
    algoliaService.addFacets(_selectedBrands, 'brandName');    // await searchCubit.searchProducts(facets: [_selectedBrands]);

    // Example: you can now use formattedBrands in your filters
    // print(formattedBrands);
  }

  void updateSelectedDep(List<String> selectedDep) async {
    _selectedDep.clear();
    _selectedDep = List.from(selectedDep); // ✔ make a full copy, not a reference
    algoliaService.addFacets(selectedDep, 'department');    // await searchCubit.searchProducts(facets: [_selectedBrands]);

    // Example: you can now use formattedBrands in your filters
    // print(formattedBrands);
  }
  void updateSelectedCateg(List<String> selectedDep) async {
    _selectedCateg.clear();
    _selectedCateg = List.from(selectedCateg); // ✔ make a full copy, not a reference
    algoliaService.addFacets(selectedCateg, 'department');    // await searchCubit.searchProducts(facets: [_selectedBrands]);

    // Example: you can now use formattedBrands in your filters
    // print(formattedBrands);
  }

  // void selectBrand(String option, bool isSelected) {
  //   FilterInitial();
  //   if (isSelected) {
  //     _selectedBrands.add('brandName:'+option);
  //   } else {
  //     _selectedBrands.remove('brandName:'+option);
  //   }
  //
  //   emit(FilterLoaded(
  //     brandsName: _brandsName,
  //     departments: _departments,
  //     categories: _categories,
  //     selectedBrands: _selectedBrands,
  //     selectedDep: _selectedDep,
  //     selectedCateg: _selectedCat,
  //   ));
  // }

  Future<void> applyStringFilter() async {
    emit(FilterLoading());
    try {
      List<List<String>> selectedFacets = [];
      selectedFacets.add(_selectedBrands);
      // selectedFacets.add(_selectedDep);
      // selectedFacets.add(_selectedCat);
      // await searchCubit.searchProducts(facets: selectedFacets,);

      emit(FilterLoaded());

    } catch (e) {
      emit(FilterError(e.toString()));
    }

  }

  //
  // // ✅ Selection for Categories
  // void selectCategory(String category, List<String> selections) {
  //   // _selectedItems[category] = selections;
  //
  //   emit(FilterLoaded(
  //     brandsName: _brandsName,
  //     departments: _departments,
  //     categories: _categories,
  //     selectedBrands: _selectedBrands,
  //     selectedDep: _selectedDep,
  //     selectedCateg: _selectedCat,
  //   ));
  // }
}