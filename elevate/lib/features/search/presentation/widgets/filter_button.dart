import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../cubits/filter/filter_cubit.dart';
import '../cubits/search/search_cubit.dart';
import '../utils/filters_utils.dart';
import 'filter_sheet.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final int filterOptions;
  final bool isHighlighted; // ✔️ Should be final
  final VoidCallback onFetch;

  const FilterButton({
    Key? key,
    required this.label,
    required this.filterOptions,
    required this.onFetch,
    this.isHighlighted = true, // ✔️ Optional default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FilterCubit>();

    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12 * SizeConfig.horizontalBlock,
          vertical: 8 * SizeConfig.verticalBlock,
        ),
        decoration: BoxDecoration(
          color: isHighlighted ? const Color(0xFFA51930) : Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12 * SizeConfig.textRatio,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white, size: 20 * SizeConfig.verticalBlock),
          ],
        ),
      ),
        onTap: () async {
        if(FilterUtils.getFacetsViewByOption(filterOptions,cubit).isEmpty) {
          onFetch();
        }
          final selectedOptions = await showModalBottomSheet<List<String>>(
            context: context,
            isScrollControlled: true,
            builder: (bottomSheetContext) {
              return BlocProvider.value(
                value: BlocProvider.of<FilterCubit>(context),
                child: FilterSheet(options: filterOptions),
              );
            },
          );
          if (selectedOptions != null && selectedOptions.isNotEmpty) {
            if (filterOptions == 2) {
              cubit.updateSelectedBrands(selectedOptions);
            } else if (filterOptions == 3) {
              cubit.updateSelectedDep(selectedOptions);
            } else if (filterOptions == 1) {
              // cubit.updateSelectedCategories(selectedOptions);
            }
            context.read<SearchCubit>().searchProducts(facets: [context.read<FilterCubit>().selectedBrands]);

          }
        }
    );
  }
}
