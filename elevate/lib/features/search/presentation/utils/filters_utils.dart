import '../cubits/filter/filter_cubit.dart';

class FilterUtils {
  static List<String> getFacetsViewByOption(int option, FilterCubit cubit) {
    switch (option) {
      case 1:
      // return cubit.categories; // Uncomment if you add category list
        return []; // Placeholder
      case 2:
        return cubit.brandsNames;
      case 3:
        return cubit.departments;
      default:
        return [];
    }
  }

  static List<String> getSelectedFacetsByOption(int option, FilterCubit cubit) {
    switch (option) {
      case 1:
      // return cubit.categories; // Uncomment if you add category list
        return []; // Placeholder
      case 2:
        return cubit.selectedBrands;
      case 3:
        return cubit.selectedDep;
      default:
        return [];
    }
  }
}
