import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../cubits/filter/filter_cubit.dart';
import '../cubits/filter/filter_state.dart';
import 'expanded_filter_checklist.dart';
import 'filter_bottom_sheet.dart';
import 'filter_checklist.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final int filterOptions;
  final bool isHighlighted;
  final VoidCallback onFetch;

  const FilterButton({
    Key? key,
    required this.label,
    required this.filterOptions,
    required this.onFetch,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        onFetch();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (bottomSheetContext) {
            return BlocProvider.value(
              value: BlocProvider.of<FilterCubit>(context),
              child: FilterBottomSheet(filterOptions: filterOptions),
            );
          },
        );
      },
    );
  }
}
