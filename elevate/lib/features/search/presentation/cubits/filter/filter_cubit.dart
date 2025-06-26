import 'package:elevate/features/product_details/data/services/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/brand_model.dart';
import '../../../data/services/brand_service.dart';
import 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  List<String> _brandsName = [];
  List<String> _departments = [];
  Map<String,List<String>> _categories= {'':[]};

  Future<void> getAllBrands() async {
    emit(FilterLoading());
    try {
      _brandsName.clear();
      _brandsName = await BrandService.getAllBrandNames();
      emit(FilterLoaded(brandsName: _brandsName, departments: _departments, categories: _categories));
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
      emit(FilterLoaded(brandsName:_brandsName,departments:  _departments, categories: _categories));
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
      emit(FilterLoaded(brandsName: _brandsName, departments: _departments, categories: _categories));
    } catch (e) {
      emit(FilterError(e.toString()));
      rethrow;
    }
  }
}