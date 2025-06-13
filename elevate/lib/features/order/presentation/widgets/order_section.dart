import 'package:flutter/material.dart';

class OrderSection extends StatelessWidget {
  final String label;
  final dynamic content;
  final bool isPlaceholder;
  final bool showArrow;

  const OrderSection({
    super.key,
    required this.label,
    required this.content,
    this.isPlaceholder = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE6E6E6), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child:
                content is List
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          (content as List)
                              .map(
                                (line) => Text(
                                  line.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isPlaceholder
                                            ? Colors.black38
                                            : Colors.black,
                                  ),
                                ),
                              )
                              .toList(),
                    )
                    : Text(
                      content.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: isPlaceholder ? Colors.black38 : Colors.black,
                      ),
                    ),
          ),
          if (showArrow) const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    );
  }
}
