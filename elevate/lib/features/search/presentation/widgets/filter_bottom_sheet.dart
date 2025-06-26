
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/filter/filter_cubit.dart';
import '../cubits/filter/filter_state.dart';
import 'expanded_filter_checklist.dart';
import 'filter_checklist.dart';

class FilterBottomSheet extends StatefulWidget {
  final int filterOptions;

  FilterBottomSheet({required this.filterOptions});

  @override
  State<FilterBottomSheet> createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {
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
              return  Center(child: CircularProgressIndicator());
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
