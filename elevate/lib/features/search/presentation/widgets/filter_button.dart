import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../cubits/filter/filter_cubit.dart';
import '../cubits/filter/filter_state.dart';
import 'expanded_filter_checklist.dart';
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
              child: _FilterBottomSheet(filterOptions: filterOptions),
            );
          },
        );
      },
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final int filterOptions;

  const _FilterBottomSheet({required this.filterOptions});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  List<String> selectedOptions = [];
  Map<String, List<String>> selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state) {
            if (state is FilterLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FilterError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is FilterLoaded) {
              final List<String> options = widget.filterOptions == 2
                  ? state.brandsName
                  : widget.filterOptions == 3
                  ? state.departments
                  : [];

              if (widget.filterOptions == 2 || widget.filterOptions == 3) {
                if (options.isEmpty) {
                  return const Center(child: Text('No options found.'));
                }

                return FilterChecklist(
                  options: options,
                  selectedOptions: selectedOptions,
                  scrollController: scrollController,
                  onApply: (selected) {
                    setState(() {
                      selectedOptions = selected;
                    });
                    Navigator.pop(context);
                  },
                  onSelect: (option, isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                    });
                  },
                );
              } else {
                final categories = state.categories;

                if (categories.keys.isEmpty) {
                  return const Center(child: Text('No options found.'));
                }

                return ExpandedFilterChecklist(
                  items: categories,
                  selectedItems: selectedItems,

                  onApply: (selections) {
                    setState(() {
                      selectedItems = selections;
                    });
                    Navigator.pop(context);
                  },
                );
              }
            } else {
              return const Center(child: Text('Start searching...'));
            }
          },
        );
      },
    );
  }
}
