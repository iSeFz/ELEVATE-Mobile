import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import '../cubits/filter/filter_cubit.dart';
import '../cubits/filter/filter_state.dart';

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
        final parentContext = context;

        showModalBottomSheet(
          context: parentContext,
          builder: (bottomSheetContext) {
            return BlocProvider.value(
              value: BlocProvider.of<FilterCubit>(parentContext),
              child: BlocBuilder<FilterCubit, FilterState>(
                builder: (context, state) {
                  if (state is FilterLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FilterError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is FilterLoaded) {
                    final options = filterOptions == 1
                        ? state.brandsName
                        : filterOptions == 2
                        ? []
                        : state.departments;

                    if (options.isEmpty) {
                      return const Center(child: Text('No options found.'));
                    }

                    // ✅ Checklist State
                    List<String> selectedOptions = [];

                    return StatefulBuilder(
                      builder: (context, setState) {
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
                                    child:ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    // You can handle selectedOptions here
                                    Navigator.pop(context);
                                  },
                                  child: Text('Apply',style: TextStyle(color: Colors.white),),
                                ))
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options[index];
                                  final isSelected = selectedOptions.contains(option);

                                  return CheckboxListTile(
                                    title: Text(option),
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedOptions.add(option);
                                        } else {
                                          selectedOptions.remove(option);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ),

                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Start searching...'));
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
