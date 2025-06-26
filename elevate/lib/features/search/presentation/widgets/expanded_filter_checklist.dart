import 'package:flutter/material.dart';

class ExpandedFilterChecklist extends StatefulWidget {
  final Map<String, List<String>> items;
  final Map<String, List<String>> selectedItems;
  final Function(Map<String, List<String>> selections) onApply;

  const ExpandedFilterChecklist({
    Key? key,
    required this.items,
    required this.selectedItems,
    required this.onApply,
  }) : super(key: key);

  @override
  State<ExpandedFilterChecklist> createState() => _ExpandedFilterChecklistState();
}

class _ExpandedFilterChecklistState extends State<ExpandedFilterChecklist> {
  late Map<String, List<String>> localSelectedItems;
  late Set<String> selectedCategories;

  @override
  void initState() {
    super.initState();
    localSelectedItems = Map.from(widget.selectedItems);
    selectedCategories = widget.selectedItems.keys.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(localSelectedItems);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA51930),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Apply', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            children: widget.items.entries.map((entry) {
              final String category = entry.key;
              final List<String> options = entry.value;
              final List<String> selectedOptions = localSelectedItems[category] ?? [];

              // ✅ CASE 1: If the category has no options → show a single checkbox
              if (options.isEmpty) {
                final bool isChecked = selectedCategories.contains(category);

                return CheckboxListTile(
                  title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedCategories.add(category);
                        localSelectedItems[category] = [];
                      } else {
                        selectedCategories.remove(category);
                        localSelectedItems.remove(category);
                      }
                    });
                  },
                );
              }

              // ✅ CASE 2: If the category has options → show an expandable tile without checkbox
              return ExpansionTile(
                title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.keyboard_arrow_down),
                children: options.map((option) {
                  final bool isChecked = selectedOptions.contains(option);

                  return CheckboxListTile(
                    title: Text(option),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedOptions.add(option);
                        } else {
                          selectedOptions.remove(option);
                        }
                        localSelectedItems[category] = selectedOptions;
                      });
                    },
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
