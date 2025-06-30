import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/order_cubit.dart';

class OrderItemCard extends StatelessWidget {
  final int index;

  const OrderItemCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final item = cubit.cartItems[index];

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x42000000), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.imageURL,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 60),
                        ),
                  ),
                ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey[700]?.withAlpha(220),
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.brandName,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    item.productName
                        .split(' ')
                        .map((word) {
                          if (word.isEmpty) return '';
                          return word[0].toUpperCase() +
                              word.substring(1).toLowerCase();
                        })
                        .join(' '),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: screenHeight * 0.001),
                  Text(
                    '${item.size} / ${item.colors.join(", ")}',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              'EGP ${(item.price * item.quantity).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
