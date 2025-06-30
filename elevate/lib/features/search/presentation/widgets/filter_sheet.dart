import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/size_config.dart';
import '../cubits/filter/filter_cubit.dart';
import '../cubits/filter/filter_state.dart';
import '../../../../core/utils/filters_utils.dart';

class FilterSheet extends StatefulWidget {
  final int options;
  final bool isExpanded;

  const FilterSheet({
    Key? key,
    required this.options,
    required this.isExpanded, // Control expanded view
  }) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<FilterCubit>();
    selectedOptions = List<String>.from(FilterUtils.getSelectedFacetsByOption(widget.options, cubit));
  }

  void toggleSelection(String option, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

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
            final cubit = context.read<FilterCubit>();

            if (state is FilterLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FilterError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is FilterLoaded) {
              List<String> facetsData = FilterUtils.getFacetsViewByOption(widget.options, cubit);

              if (facetsData.isEmpty) {
                return const Center(child: Text('No filters found.'));
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12 * SizeConfig.horizontalBlock,
                          vertical: 10 * SizeConfig.verticalBlock,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA51930),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, selectedOptions);
                          },
                          child: const Text('Apply', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: widget.isExpanded
                        ? buildExpandableList(facetsData, scrollController)
                        : buildSimpleList(facetsData, scrollController),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Start searching...'));
            }
          },
        );
      },
    );
  }

  Widget buildSimpleList(List<String> data, ScrollController controller) {
    return ListView.builder(
      controller: controller,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final option = data[index];
        final isSelected = selectedOptions.contains(option);

        return CheckboxListTile(
          title: Text(option),
          value: isSelected,
          onChanged: (bool? value) => toggleSelection(option, isSelected),
        );
      },
    );
  }

  Widget buildExpandableList(List<String> data, ScrollController controller) {
    Map<String, List<String>> groupedItems = {};
    List<String> singleItems = [];

    // Group items based on the dash
    for (var item in data) {
      if (item.contains('-')) {
        final parts = item.split('-');
        final key = parts[0].trim();
        final value = parts.sublist(1).join('-').trim();

        if (!groupedItems.containsKey(key)) {
          groupedItems[key] = [];
        }
        groupedItems[key]!.add(value);
      } else {
        singleItems.add(item.trim());
      }
    }

    return ListView(
      controller: controller,
      children: [
        // Items without dash (ungrouped)
        ...singleItems.map((option) {
          final isSelected = selectedOptions.contains(option);
          return CheckboxListTile(
            title: Text(option),
            value: isSelected,
            onChanged: (bool? value) => toggleSelection(option, isSelected),
          );
        }).toList(),

        // Grouped items (categories, sets, etc.)
        ...groupedItems.entries.map((entry) {
          final groupTitle = entry.key;
          final groupItems = entry.value;

          // Check if all group items are selected
          final isGroupSelected = groupItems.every((val) => selectedOptions.contains('$groupTitle - $val'));

          return ExpansionTile(
            title: Row(
              children: [
                Checkbox(
                  value: isGroupSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        // Select all items in this group
                        groupItems.forEach((val) {
                          final fullValue = '$groupTitle - $val';
                          if (!selectedOptions.contains(fullValue)) {
                            selectedOptions.add(fullValue);
                          }
                        });
                      } else {
                        // Deselect all items in this group
                        groupItems.forEach((val) {
                          final fullValue = '$groupTitle - $val';
                          selectedOptions.remove(fullValue);
                        });
                      }
                    });
                  },
                ),
                Text(groupTitle),
              ],
            ),
            children: groupItems.map((val) {
              final fullValue = '$groupTitle - $val';
              final isSelected = selectedOptions.contains(fullValue);

              return CheckboxListTile(
                title: Text(val),
                value: isSelected,
                onChanged: (bool? value) => toggleSelection(fullValue, isSelected),
              );
            }).toList(),
          );
        }).toList(),
      ],
    );
  }


}
