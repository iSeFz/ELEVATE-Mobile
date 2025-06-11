import 'package:flutter/material.dart';
import 'dart:math';
import '../../data/models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final int index;
  final void Function(int index, int quantityChange) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageURL,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Brand: ${item.brandName}',
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Size: ${item.size}',
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Colors: ${item.colors.join(", ")}',
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'In stock: ${item.productStock ?? "-"}',
                    style: const TextStyle(color: Colors.green, fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "EGP ${item.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<int>(
                  value: item.quantity,
                  items: List.generate(
                    min(10, item.productStock ?? 10),
                    (i) =>
                        DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      onQuantityChanged(index, value - item.quantity);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
