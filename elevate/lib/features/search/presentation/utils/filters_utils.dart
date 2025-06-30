import '../cubits/filter/filter_cubit.dart';

class FilterUtils {
  static List<String> getFacetsViewByOption(int option, FilterCubit cubit) {
    switch (option) {
      case 1:
        return cubit.categories; // Uncomment if you add category list
      case 2:
        return cubit.brandsNames;
      case 3:
        return cubit.departments;
      case 4:
        return cubit.colors;
      default:
        return [];
    }
  }

  static List<String> getSelectedFacetsByOption(int option, FilterCubit cubit) {
    switch (option) {
      case 1:
        return cubit.selectedCateg;
      case 2:
        return cubit.selectedBrands;
      case 3:
        return cubit.selectedDep;
      case 4:
        return cubit.selectedColors;
      default:
        return [];
    }
  }

  static void updateSelectedOptions(int filterOptions, List<String> selectedOptions, FilterCubit cubit) {
    switch (filterOptions) {
      case 1:
        cubit.updateSelectedCateg(selectedOptions);
        break;
      case 2:
        cubit.updateSelectedBrands(selectedOptions);
        break;
      case 3:
        cubit.updateSelectedDep(selectedOptions);
        break;
      case 4:
        cubit.updateSelectedColors(selectedOptions);
        break;
      default:
      // Optional: Handle unknown cases if needed
        break;
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
