import '../cubits/filter/filter_cubit.dart';

class FilterUtils {
  static List<String> getFacetsViewByOption(int option, FilterCubit cubit) {
    switch (option) {
      case 1:
        return cubit.categories; // Uncomment if you add category list
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
        return cubit.selectedCateg; // Uncomment if you add category list
        return []; // Placeholder
      case 2:
        return cubit.selectedBrands;
      case 3:
        return cubit.selectedDep;
      default:
        return [];
    }
  }

  static Map<String, List<String>> getMappedCategories(List<String>categories){

      final Map<String, List<String>> mappedCategories = {};
      for (final item in categories) {
        if (item.contains(' - ')) {
          final parts = item.split(' - ');
          final key = parts[0].trim();
          final value = parts[1].trim();
          if (!mappedCategories.containsKey(key)) {
            mappedCategories[key] = [];
          }
          mappedCategories[key]!.add(value);
        } else {
          mappedCategories.putIfAbsent(item, () => []);
        }
      }

      return mappedCategories;

  }
}
