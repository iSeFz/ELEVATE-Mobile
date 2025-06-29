// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../core/utils/size_config.dart';
//
// class FilterChecklist extends StatelessWidget {
//   final List<String> options;
//   final List<String> selectedOptions;
//   final ScrollController scrollController;
//   final Function(List<String>) onApply;
//   final Function(String, bool) onSelect;
//
//   const FilterChecklist({
//     Key? key,
//     required this.options,
//     required this.selectedOptions,
//     required this.scrollController,
//     required this.onApply,
//     required this.onSelect,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 12 * SizeConfig.horizontalBlock,
//                 vertical: 10 * SizeConfig.verticalBlock,
//               ),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFA51930),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () {
//                   onApply(selectedOptions);
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Apply', style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ],
//         ),
//         Expanded(
//           child: ListView.builder(
//             controller: scrollController,
//             itemCount: options.length,
//             itemBuilder: (context, index) {
//               final option = options[index];
//               final isSelected = selectedOptions.contains(option);
//
//               return CheckboxListTile(
//                 title: Text(option),
//                 value: isSelected,
//                 onChanged: (bool? value) {
//                   onSelect(option, value ?? false);
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
