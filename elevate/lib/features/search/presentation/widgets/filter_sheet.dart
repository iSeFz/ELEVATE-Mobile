import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/size_config.dart';
import '../cubits/filter/filter_cubit.dart';
import '../cubits/filter/filter_state.dart';
import '../utils/filters_utils.dart';

class FilterSheet extends StatefulWidget {
  final int options;

  const FilterSheet({
    Key? key,
    required this.options,
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

    // Initialize selected options from cubit when sheet is first opened
    selectedOptions = List<String>.from(FilterUtils.getSelectedFacetsByOption(widget.options, cubit));
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
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: facetsData.length,
                      itemBuilder: (context, index) {
                        final option = facetsData[index];
                        final isSelected = selectedOptions.contains(option);

                        return CheckboxListTile(
                          title: Text(option),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (isSelected) {
                                selectedOptions.remove(option);
                              } else {
                                selectedOptions.add(option);
                              }
                            });
                          },
                        );
                      },
                    ),
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
}

